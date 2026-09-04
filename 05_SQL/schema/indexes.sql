-- ============================================================
-- DAYJOY AI ASSIST — INDEXES FOR NEW (EXTENSION) TABLES
-- ============================================================
-- Indexes for tables already created in dayjoy_database_schema.sql
-- are defined inline in that file and are NOT repeated here.
-- Most indexes below are also declared inline in
-- dayjoy_full_production_schema.sql; this file consolidates them in
-- one place for review/ops convenience. Safe to re-run (IF NOT EXISTS).
-- ============================================================

-- ROLES / PROFILES / USER_ROLES
create index if not exists idx_profiles_primary_role on profiles(primary_role_id);
create index if not exists idx_profiles_status on profiles(status);
create index if not exists idx_user_roles_profile on user_roles(profile_id);
create index if not exists idx_user_roles_role on user_roles(role_id);

-- PRODUCT_VARIANTS
create index if not exists idx_product_variants_product on product_variants(product_id);
create index if not exists idx_product_variants_sku on product_variants(variant_sku);
create index if not exists idx_product_variants_status on product_variants(status);

-- PRODUCT_PRICES (history)
create index if not exists idx_product_prices_product on product_prices(product_id);
create index if not exists idx_product_prices_effective_from on product_prices(effective_from);
create index if not exists idx_product_prices_effective_to on product_prices(effective_to);
-- uq_product_prices_current and excl_product_prices_no_overlap are
-- declared in dayjoy_full_production_schema.sql alongside the table.

-- PRODUCT_INGREDIENTS / PRODUCT_BENEFITS
create index if not exists idx_product_ingredients_product on product_ingredients(product_id);
create index if not exists idx_product_benefits_product on product_benefits(product_id);
create index if not exists idx_product_benefits_category on product_benefits(benefit_category);

-- COMPANY_DOCUMENTS / POLICIES / COMPENSATION_RULES
create index if not exists idx_company_documents_type on company_documents(document_type);
create index if not exists idx_company_documents_status on company_documents(status);
create index if not exists idx_policies_type on policies(policy_type);
create index if not exists idx_policies_applies_to on policies(applies_to);
create index if not exists idx_compensation_rules_rank on compensation_rules(rank_id);
create index if not exists idx_compensation_rules_type on compensation_rules(rule_type);

-- TRAINING_CONTENT
create index if not exists idx_training_content_category on training_content(category);
create index if not exists idx_training_content_audience on training_content(target_audience);
create index if not exists idx_training_content_status on training_content(status);

-- KNOWLEDGE_SOURCES / KNOWLEDGE_DOCUMENTS
create index if not exists idx_knowledge_sources_status on knowledge_sources(status);
create index if not exists idx_knowledge_documents_source on knowledge_documents(source_id);
create index if not exists idx_knowledge_documents_type on knowledge_documents(document_type);

-- CONVERSATIONS / MESSAGES / MEMORIES
create index if not exists idx_conversations_profile on conversations(profile_id);
create index if not exists idx_conversations_status on conversations(status);
create index if not exists idx_messages_conversation on messages(conversation_id);
create index if not exists idx_messages_sender on messages(sender_id);
create index if not exists idx_memories_profile on memories(profile_id);

-- DISTRIBUTORS / TEAMS / LEADERS / CUSTOMERS
create index if not exists idx_distributors_sponsor on distributors(sponsor_distributor_id);
create index if not exists idx_distributors_rank on distributors(current_rank_id);
create index if not exists idx_distributors_status on distributors(status);
create index if not exists idx_distributors_code on distributors(distributor_code);
create index if not exists idx_teams_lead on teams(lead_distributor_id);
create index if not exists idx_leaders_team on leaders(team_id);
create index if not exists idx_customers_referred_by on customers(referred_by_distributor_id);
create index if not exists idx_customers_code on customers(customer_code);

-- ORDERS / ORDER_ITEMS / SALES
create index if not exists idx_orders_customer on orders(customer_id);
create index if not exists idx_orders_distributor on orders(distributor_id);
create index if not exists idx_orders_status on orders(order_status);
create index if not exists idx_orders_payment_status on orders(payment_status);
create index if not exists idx_orders_date on orders(order_date);
create index if not exists idx_order_items_order on order_items(order_id);
create index if not exists idx_order_items_product on order_items(product_id);
create index if not exists idx_sales_distributor on sales(distributor_id);
create index if not exists idx_sales_product on sales(product_id);
create index if not exists idx_sales_customer on sales(customer_id);
create index if not exists idx_sales_date on sales(sale_date);

-- BV / PV / TARGETS / RANK_HISTORY
create index if not exists idx_bv_transactions_distributor on bv_transactions(distributor_id);
create index if not exists idx_bv_transactions_period on bv_transactions(period_week);
create index if not exists idx_pv_transactions_distributor on pv_transactions(distributor_id);
create index if not exists idx_pv_transactions_period on pv_transactions(period_month);
create index if not exists idx_targets_distributor on targets(distributor_id);
create index if not exists idx_targets_period on targets(period_start, period_end);
create index if not exists idx_targets_status on targets(status);
create index if not exists idx_rank_history_distributor on rank_history(distributor_id);
create index if not exists idx_rank_history_rank on rank_history(rank_id);

-- SUPPORT_TICKETS
create index if not exists idx_support_tickets_status on support_tickets(status);
create index if not exists idx_support_tickets_priority on support_tickets(priority);
create index if not exists idx_support_tickets_customer on support_tickets(customer_id);
create index if not exists idx_support_tickets_distributor on support_tickets(distributor_id);
create index if not exists idx_support_tickets_assigned_to on support_tickets(assigned_to);
-- ============================================================
