-- ============================================================
-- DRAFT — needs security review before production deployment.
-- ============================================================
-- DAYJOY AI ASSIST — ROW LEVEL SECURITY (RLS) POLICY STUBS
-- Scope: tables introduced in dayjoy_full_production_schema.sql only.
-- Tables already in dayjoy_database_schema.sql (products, categories,
-- knowledge_chunks, etc.) are public catalog/RAG data and are assumed
-- readable by anon/authenticated roles already; add RLS there
-- separately if/when write access needs restricting.
--
-- ROLE NAMING NOTE:
-- The `roles` table (see dayjoy_full_production_schema.sql, section 14)
-- defines app-level roles: 'customer', 'distributor', 'leader', 'admin',
-- 'support'. The existing RAG content in 04_RAG/chunks/*.csv instead
-- tags each chunk with a `role_scope` column using lowercase
-- CONTENT-VISIBILITY labels observed in the data: 'public',
-- 'distributor', 'internal', 'support' (e.g. "public, distributor,
-- internal"). These are two different vocabularies for two different
-- purposes (who-can-do-what vs. what-content-is-visible-to-whom).
-- Suggested mapping used below:
--   app role 'customer'      ~ content scope 'public'
--   app role 'distributor'   ~ content scope 'distributor'
--   app role 'leader'        ~ content scope 'distributor' (+ team-level access)
--   app role 'support'       ~ content scope 'support'
--   app role 'admin'         ~ content scope 'internal' (full access)
-- Confirm this mapping with product/eng before relying on it for
-- anything sensitive (PII, payouts, KYC).
-- ============================================================

-- ------------------------------------------------------------
-- Helper: current user's role names (assumes Supabase auth.uid())
-- ------------------------------------------------------------
create or replace function current_profile_id()
returns uuid
language sql stable
as $$
  select profile_id from profiles where auth_user_id = auth.uid();
$$;

create or replace function has_role(check_role text)
returns boolean
language sql stable
as $$
  select exists (
    select 1
    from user_roles ur
    join roles r on r.role_id = ur.role_id
    where ur.profile_id = current_profile_id()
      and r.role_name = check_role
  );
$$;

-- ============================================================
-- PROFILES
-- ============================================================
alter table profiles enable row level security;

drop policy if exists profiles_select_own on profiles;
create policy profiles_select_own on profiles
  for select using (auth_user_id = auth.uid() or has_role('admin') or has_role('support'));

drop policy if exists profiles_update_own on profiles;
create policy profiles_update_own on profiles
  for update using (auth_user_id = auth.uid() or has_role('admin'));

-- ============================================================
-- USER_ROLES — admin-managed only
-- ============================================================
alter table user_roles enable row level security;

drop policy if exists user_roles_admin_all on user_roles;
create policy user_roles_admin_all on user_roles
  for all using (has_role('admin'));

drop policy if exists user_roles_select_own on user_roles;
create policy user_roles_select_own on user_roles
  for select using (profile_id = current_profile_id());

-- ============================================================
-- CONVERSATIONS / MESSAGES / MEMORIES — owner-only, admin/support override
-- ============================================================
alter table conversations enable row level security;
alter table messages enable row level security;
alter table memories enable row level security;

drop policy if exists conversations_owner on conversations;
create policy conversations_owner on conversations
  for all using (profile_id = current_profile_id() or has_role('admin') or has_role('support'));

drop policy if exists messages_owner on messages;
create policy messages_owner on messages
  for all using (
    conversation_id in (select conversation_id from conversations where profile_id = current_profile_id())
    or has_role('admin') or has_role('support')
  );

drop policy if exists memories_owner on memories;
create policy memories_owner on memories
  for all using (profile_id = current_profile_id() or has_role('admin'));

-- ============================================================
-- CUSTOMERS — self, referring distributor, support, admin
-- ============================================================
alter table customers enable row level security;

drop policy if exists customers_self_or_staff on customers;
create policy customers_self_or_staff on customers
  for select using (
    profile_id = current_profile_id()
    or has_role('admin') or has_role('support')
    or referred_by_distributor_id in (
      select distributor_id from distributors where profile_id = current_profile_id()
    )
  );

drop policy if exists customers_admin_write on customers;
create policy customers_admin_write on customers
  for insert with check (has_role('admin') or has_role('distributor'));

drop policy if exists customers_admin_update on customers;
create policy customers_admin_update on customers
  for update using (has_role('admin') or profile_id = current_profile_id());

-- ============================================================
-- DISTRIBUTORS / LEADERS / TEAMS — self, team, admin
-- ============================================================
alter table distributors enable row level security;
alter table leaders enable row level security;
alter table teams enable row level security;

drop policy if exists distributors_self_or_admin on distributors;
create policy distributors_self_or_admin on distributors
  for select using (profile_id = current_profile_id() or has_role('admin') or has_role('support'));

drop policy if exists distributors_self_update on distributors;
create policy distributors_self_update on distributors
  for update using (profile_id = current_profile_id() or has_role('admin'));

drop policy if exists leaders_visible_to_team on leaders;
create policy leaders_visible_to_team on leaders
  for select using (has_role('leader') or has_role('admin') or has_role('support'));

drop policy if exists teams_visible_to_members on teams;
create policy teams_visible_to_members on teams
  for select using (has_role('distributor') or has_role('leader') or has_role('admin'));

-- ============================================================
-- ORDERS / ORDER_ITEMS / SALES — owner (customer or distributor), admin
-- ============================================================
alter table orders enable row level security;
alter table order_items enable row level security;
alter table sales enable row level security;

drop policy if exists orders_owner_or_admin on orders;
create policy orders_owner_or_admin on orders
  for select using (
    has_role('admin') or has_role('support')
    or customer_id in (select customer_id from customers where profile_id = current_profile_id())
    or distributor_id in (select distributor_id from distributors where profile_id = current_profile_id())
  );

drop policy if exists order_items_via_order on order_items;
create policy order_items_via_order on order_items
  for select using (
    has_role('admin') or has_role('support')
    or order_id in (select order_id from orders) -- TODO: tighten to owner's orders once join perf is validated
  );

drop policy if exists sales_owner_or_admin on sales;
create policy sales_owner_or_admin on sales
  for select using (
    has_role('admin') or has_role('support')
    or distributor_id in (select distributor_id from distributors where profile_id = current_profile_id())
  );

-- ============================================================
-- BV_TRANSACTIONS / PV_TRANSACTIONS / TARGETS / RANK_HISTORY
-- Financial/performance data — distributor sees own, admin sees all.
-- ============================================================
alter table bv_transactions enable row level security;
alter table pv_transactions enable row level security;
alter table targets enable row level security;
alter table rank_history enable row level security;

drop policy if exists bv_transactions_owner on bv_transactions;
create policy bv_transactions_owner on bv_transactions
  for select using (
    has_role('admin')
    or distributor_id in (select distributor_id from distributors where profile_id = current_profile_id())
  );

drop policy if exists pv_transactions_owner on pv_transactions;
create policy pv_transactions_owner on pv_transactions
  for select using (
    has_role('admin')
    or distributor_id in (select distributor_id from distributors where profile_id = current_profile_id())
  );

drop policy if exists targets_owner on targets;
create policy targets_owner on targets
  for select using (
    has_role('admin')
    or distributor_id in (select distributor_id from distributors where profile_id = current_profile_id())
  );

drop policy if exists rank_history_owner on rank_history;
create policy rank_history_owner on rank_history
  for select using (
    has_role('admin')
    or distributor_id in (select distributor_id from distributors where profile_id = current_profile_id())
  );

-- ============================================================
-- SUPPORT_TICKETS — requester, assignee, support, admin
-- ============================================================
alter table support_tickets enable row level security;

drop policy if exists support_tickets_visible on support_tickets;
create policy support_tickets_visible on support_tickets
  for select using (
    has_role('admin') or has_role('support')
    or profile_id = current_profile_id()
    or assigned_to = current_profile_id()
  );

drop policy if exists support_tickets_create on support_tickets;
create policy support_tickets_create on support_tickets
  for insert with check (profile_id = current_profile_id() or has_role('support') or has_role('admin'));

drop policy if exists support_tickets_update on support_tickets;
create policy support_tickets_update on support_tickets
  for update using (has_role('support') or has_role('admin') or assigned_to = current_profile_id());

-- ============================================================
-- CONTENT / REFERENCE TABLES — readable by any authenticated role,
-- writable by admin only. (product_variants, product_prices,
-- product_ingredients, product_benefits, company_documents, policies,
-- compensation_rules, training_content, knowledge_sources,
-- knowledge_documents)
-- ============================================================
alter table product_variants enable row level security;
alter table product_prices enable row level security;
alter table product_ingredients enable row level security;
alter table product_benefits enable row level security;
alter table company_documents enable row level security;
alter table policies enable row level security;
alter table compensation_rules enable row level security;
alter table training_content enable row level security;
alter table knowledge_sources enable row level security;
alter table knowledge_documents enable row level security;

drop policy if exists content_read_all_authenticated on product_variants;
create policy content_read_all_authenticated on product_variants for select using (auth.role() = 'authenticated' or auth.role() = 'anon');
drop policy if exists content_write_admin on product_variants;
create policy content_write_admin on product_variants for insert with check (has_role('admin'));

drop policy if exists content_read_all_authenticated on product_prices;
create policy content_read_all_authenticated on product_prices for select using (auth.role() = 'authenticated' or auth.role() = 'anon');
drop policy if exists content_write_admin on product_prices;
create policy content_write_admin on product_prices for insert with check (has_role('admin'));

drop policy if exists content_read_all_authenticated on product_ingredients;
create policy content_read_all_authenticated on product_ingredients for select using (auth.role() = 'authenticated' or auth.role() = 'anon');

drop policy if exists content_read_all_authenticated on product_benefits;
create policy content_read_all_authenticated on product_benefits for select using (auth.role() = 'authenticated' or auth.role() = 'anon');

drop policy if exists content_read_distributor_plus on company_documents;
create policy content_read_distributor_plus on company_documents
  for select using (has_role('distributor') or has_role('leader') or has_role('admin') or has_role('support'));

drop policy if exists policies_read_scoped on policies;
create policy policies_read_scoped on policies
  for select using (
    applies_to = 'all'
    or (applies_to = 'customer' and has_role('customer'))
    or (applies_to = 'distributor' and (has_role('distributor') or has_role('leader')))
    or (applies_to = 'leader' and has_role('leader'))
    or has_role('admin')
  );

drop policy if exists compensation_rules_distributor_plus on compensation_rules;
create policy compensation_rules_distributor_plus on compensation_rules
  for select using (has_role('distributor') or has_role('leader') or has_role('admin'));

drop policy if exists training_content_scoped on training_content;
create policy training_content_scoped on training_content
  for select using (
    target_audience = 'all'
    or (target_audience = 'customer' and has_role('customer'))
    or (target_audience = 'distributor' and (has_role('distributor') or has_role('leader')))
    or (target_audience = 'leader' and has_role('leader'))
    or has_role('admin')
  );

drop policy if exists knowledge_sources_admin_only on knowledge_sources;
create policy knowledge_sources_admin_only on knowledge_sources
  for all using (has_role('admin'));

drop policy if exists knowledge_documents_admin_only on knowledge_documents;
create policy knowledge_documents_admin_only on knowledge_documents
  for all using (has_role('admin'));

-- ============================================================
-- ROLES — readable by all authenticated, writable by admin only
-- ============================================================
alter table roles enable row level security;
drop policy if exists roles_read_all on roles;
create policy roles_read_all on roles for select using (true);
drop policy if exists roles_write_admin on roles;
create policy roles_write_admin on roles for insert with check (has_role('admin'));

-- ============================================================
-- END OF DRAFT RLS POLICIES — review before production deployment.
-- ============================================================
