-- ============================================================
-- DAYJOY AI ASSIST — FULL PRODUCTION SCHEMA (EXTENSION)
-- ============================================================
-- This file EXTENDS the reconciled canonical schema. It does NOT
-- redefine or duplicate any table already created by:
--   05_SQL/schema/dayjoy_database_schema.sql
--     (categories, brands, products, product_images, product_faqs,
--      product_relationships, condition_recommendations, plan_ranks,
--      business_matching_rules, plan_faqs, knowledge_chunks, audit_log)
--
-- knowledge_chunks (from dayjoy_database_schema.sql) is the CANONICAL
-- RAG store. dayjoy_unified_rag_corpus (defined in
-- dayjoy_postgresql_schema_supplement.sql) must NOT be used or
-- migrated into — it is superseded. See T015_SCHEMA_RECONCILIATION.md.
--
-- Run AFTER dayjoy_database_schema.sql. Safe to re-run (all
-- statements are idempotent via IF NOT EXISTS).
--
-- Section numbering continues from dayjoy_database_schema.sql
-- (sections 1–13), starting at 14.
-- ============================================================

create extension if not exists "uuid-ossp";
create extension if not exists pg_trgm;
create extension if not exists btree_gist; -- required for the product_prices exclusion constraint

-- Reusable updated_at trigger function already created in
-- dayjoy_database_schema.sql as set_updated_at(). Reused below.

-- ============================================================
-- 14. ROLES
-- ============================================================
-- App-level authorization roles. NOTE: this is a distinct concept from
-- the `role_scope` tag found on RAG content (04_RAG/chunks/*.csv), which
-- uses lowercase content-visibility labels ('public','distributor',
-- 'internal','support'). The mapping between the two is documented in
-- 05_SQL/schema/rls_policies.sql.
create table if not exists roles (
    role_id serial primary key,
    role_name text not null unique check (role_name in ('customer','distributor','leader','admin','support')),
    description text,
    created_at timestamptz default now()
);

-- ============================================================
-- 15. PROFILES
-- ============================================================
-- One row per authenticated app user. NOTE: assumes Supabase's
-- built-in `auth.users` table. If deploying to vanilla PostgreSQL
-- (no Supabase auth schema), drop the FK to auth.users and treat
-- profile_id as a standalone uuid.
create table if not exists profiles (
    profile_id uuid primary key default uuid_generate_v4(),
    auth_user_id uuid unique, -- references auth.users(id) on Supabase; left unconstrained for portability
    full_name text,
    email text unique,
    phone text unique,
    avatar_url text,
    primary_role_id int references roles(role_id),
    status text default 'active' check (status in ('active','inactive','suspended')),
    locale text default 'en-IN',
    created_at timestamptz default now(),
    updated_at timestamptz default now()
);

drop trigger if exists trg_profiles_updated on profiles;
create trigger trg_profiles_updated before update on profiles
for each row execute function set_updated_at();

-- ============================================================
-- 16. USER_ROLES (many-to-many; a profile can hold >1 role, e.g. distributor + support)
-- ============================================================
create table if not exists user_roles (
    user_role_id serial primary key,
    profile_id uuid not null references profiles(profile_id) on delete cascade,
    role_id int not null references roles(role_id) on delete cascade,
    assigned_at timestamptz default now(),
    assigned_by uuid references profiles(profile_id),
    constraint uq_user_role unique (profile_id, role_id)
);

-- ============================================================
-- 17. PRODUCT_VARIANTS
-- ============================================================
-- For products sold in multiple pack sizes/variants that should stay
-- grouped under one parent product record.
create table if not exists product_variants (
    variant_id serial primary key,
    product_id int not null references products(product_id) on delete cascade,
    variant_name text not null,
    variant_sku text unique,
    pack_size text,
    attributes jsonb, -- e.g. {"flavor": "mint", "color": "red"}
    status text default 'active' check (status in ('active','inactive','discontinued')),
    sort_order int default 0,
    created_at timestamptz default now(),
    updated_at timestamptz default now()
);

drop trigger if exists trg_product_variants_updated on product_variants;
create trigger trg_product_variants_updated before update on product_variants
for each row execute function set_updated_at();

-- ============================================================
-- 18. PRODUCT_PRICES (price history — fixes the price-versioning gap
--     flagged in the prior pricing audit: products.mrp/dp/bv/pv only
--     stores the CURRENT snapshot; this table stores every version
--     over time with an explicit effective window)
-- ============================================================
create table if not exists product_prices (
    price_id bigserial primary key,
    product_id int not null references products(product_id) on delete cascade,
    mrp numeric(12,2) not null check (mrp >= 0),
    dp numeric(12,2) not null check (dp >= 0),
    bv numeric(12,2) default 0 check (bv >= 0),
    pv numeric(12,2) default 0 check (pv >= 0),
    currency text default 'INR',
    effective_from date not null,
    effective_to date, -- NULL = currently in effect
    source_document text, -- e.g. 'India-BV-Price-May-2026.pdf'
    change_reason text,
    approved_by text,
    created_at timestamptz default now(),
    constraint chk_price_window check (effective_to is null or effective_to >= effective_from),
    -- prevents two overlapping price windows for the same product
    constraint excl_product_prices_no_overlap exclude using gist (
        product_id with =,
        daterange(effective_from, effective_to, '[]') with &&
    )
);

-- exactly one "current" (open-ended) price row per product at a time
create unique index if not exists uq_product_prices_current on product_prices(product_id) where effective_to is null;
create index if not exists idx_product_prices_product on product_prices(product_id);
create index if not exists idx_product_prices_effective_from on product_prices(effective_from);

-- ============================================================
-- 19. PRODUCT_INGREDIENTS
-- ============================================================
create table if not exists product_ingredients (
    ingredient_id serial primary key,
    product_id int not null references products(product_id) on delete cascade,
    ingredient_name text not null,
    quantity text,
    unit text,
    is_active_ingredient boolean default false,
    sort_order int default 0,
    source text,
    created_at timestamptz default now()
);

create index if not exists idx_product_ingredients_product on product_ingredients(product_id);

-- ============================================================
-- 20. PRODUCT_BENEFITS
-- ============================================================
create table if not exists product_benefits (
    benefit_id serial primary key,
    product_id int not null references products(product_id) on delete cascade,
    benefit_text text not null,
    benefit_category text, -- e.g. 'digestion','skin','immunity'
    sort_order int default 0,
    source text,
    created_at timestamptz default now()
);

create index if not exists idx_product_benefits_product on product_benefits(product_id);

-- ============================================================
-- 21. COMPANY_DOCUMENTS
-- ============================================================
create table if not exists company_documents (
    document_id serial primary key,
    document_name text not null,
    document_type text check (document_type in ('policy','brochure','certificate','legal','compensation_plan','training','press','other')),
    file_path text,
    version text,
    effective_date date,
    status text default 'active' check (status in ('active','superseded','draft','archived')),
    source text,
    created_at timestamptz default now(),
    updated_at timestamptz default now()
);

drop trigger if exists trg_company_documents_updated on company_documents;
create trigger trg_company_documents_updated before update on company_documents
for each row execute function set_updated_at();

-- ============================================================
-- 22. POLICIES
-- ============================================================
create table if not exists policies (
    policy_id serial primary key,
    policy_type text not null check (policy_type in (
        'refund','replacement','cancellation','shipping','delivery',
        'privacy','terms_of_service','warranty','complaint','escalation','other'
    )),
    title text not null,
    content text not null,
    applies_to text default 'all' check (applies_to in ('customer','distributor','leader','all')),
    source_document_id int references company_documents(document_id),
    effective_from date,
    effective_to date,
    status text default 'active' check (status in ('active','superseded','draft')),
    created_at timestamptz default now(),
    updated_at timestamptz default now()
);

drop trigger if exists trg_policies_updated on policies;
create trigger trg_policies_updated before update on policies
for each row execute function set_updated_at();

create index if not exists idx_policies_type on policies(policy_type);

-- ============================================================
-- 23. COMPENSATION_RULES
-- ============================================================
-- Structured extraction target for the compensation-plan narrative
-- (e.g. 04_Distributor_System.md). Links to the existing plan_ranks
-- and business_matching_rules tables rather than duplicating them.
create table if not exists compensation_rules (
    rule_id serial primary key,
    rule_type text not null check (rule_type in (
        'rank_qualification','retail_bonus','royalty','binary_matching',
        'leadership_bonus','reward','mentorship_incentive','other'
    )),
    rank_id int references plan_ranks(rank_id),
    business_matching_rule_id int references business_matching_rules(rule_id),
    title text not null,
    description text,
    formula text,
    criteria jsonb,
    value_type text check (value_type in ('percentage','fixed_amount_rs','multiplier')),
    value numeric(14,4),
    source_document_id int references company_documents(document_id),
    source_page int,
    effective_from date,
    effective_to date,
    created_at timestamptz default now()
);

create index if not exists idx_compensation_rules_rank on compensation_rules(rank_id);

-- ============================================================
-- 24. TRAINING_CONTENT
-- ============================================================
create table if not exists training_content (
    training_id serial primary key,
    title text not null,
    content_type text check (content_type in ('video','document','script','presentation','audio','checklist')),
    category text check (category in (
        'onboarding','product_knowledge','sales_script','objection_handling',
        'follow_up','retention','presentation_skills','leadership','compliance','other'
    )),
    level text default 'beginner' check (level in ('beginner','intermediate','advanced')),
    target_audience text default 'distributor' check (target_audience in ('customer','distributor','leader','all')),
    content_body text,
    content_url text,
    is_official boolean default true, -- false = AI-generated suggestion, pending review
    source text,
    status text default 'draft' check (status in ('draft','approved','archived')),
    created_at timestamptz default now(),
    updated_at timestamptz default now()
);

drop trigger if exists trg_training_content_updated on training_content;
create trigger trg_training_content_updated before update on training_content
for each row execute function set_updated_at();

-- ============================================================
-- 25. KNOWLEDGE_SOURCES
-- ============================================================
-- Registry of raw source documents/files ingested into the KB
-- (independent of, and upstream from, knowledge_chunks).
create table if not exists knowledge_sources (
    source_id serial primary key,
    source_name text not null,
    source_type text check (source_type in ('pdf','csv','docx','web','manual_entry','image','other')),
    file_path text,
    checksum text,
    version text,
    ingested_at timestamptz,
    status text default 'active' check (status in ('active','superseded','archived')),
    created_at timestamptz default now()
);

-- ============================================================
-- 26. KNOWLEDGE_DOCUMENTS
-- ============================================================
-- Logical documents parsed out of knowledge_sources, prior to chunking.
-- Related to knowledge_chunks by convention (source_file/title match),
-- not by FK, so as not to alter the existing reconciled knowledge_chunks
-- table. See 05_SQL/schema/relationships.sql.
create table if not exists knowledge_documents (
    document_id serial primary key,
    source_id int references knowledge_sources(source_id) on delete set null,
    title text not null,
    document_type text check (document_type in ('product','faq','plan','policy','training','company_info','other')),
    content text,
    metadata jsonb,
    chunk_count int default 0,
    status text default 'active' check (status in ('active','superseded','archived')),
    created_at timestamptz default now(),
    updated_at timestamptz default now()
);

drop trigger if exists trg_knowledge_documents_updated on knowledge_documents;
create trigger trg_knowledge_documents_updated before update on knowledge_documents
for each row execute function set_updated_at();

-- ============================================================
-- 27. CONVERSATIONS
-- ============================================================
create table if not exists conversations (
    conversation_id uuid primary key default uuid_generate_v4(),
    profile_id uuid references profiles(profile_id) on delete set null,
    channel text check (channel in ('web','whatsapp','app','telegram','admin_console','other')),
    started_at timestamptz default now(),
    ended_at timestamptz,
    status text default 'active' check (status in ('active','closed','escalated')),
    context jsonb,
    created_at timestamptz default now()
);

create index if not exists idx_conversations_profile on conversations(profile_id);

-- ============================================================
-- 28. MESSAGES
-- ============================================================
create table if not exists messages (
    message_id bigserial primary key,
    conversation_id uuid not null references conversations(conversation_id) on delete cascade,
    sender_type text not null check (sender_type in ('user','assistant','system')),
    sender_id uuid references profiles(profile_id),
    message_text text not null,
    intent text,
    matched_chunk_ids uuid[], -- optional pointers into knowledge_chunks.chunk_id
    confidence numeric(4,3),
    tokens_used int,
    created_at timestamptz default now()
);

create index if not exists idx_messages_conversation on messages(conversation_id);

-- ============================================================
-- 29. MEMORIES
-- ============================================================
-- Long-term assistant memory per user (preferences, recurring facts).
create table if not exists memories (
    memory_id bigserial primary key,
    profile_id uuid not null references profiles(profile_id) on delete cascade,
    memory_type text check (memory_type in ('preference','fact','context','reminder')),
    memory_key text not null,
    memory_value text not null,
    source_conversation_id uuid references conversations(conversation_id),
    confidence numeric(4,3) default 0.8,
    expires_at timestamptz,
    created_at timestamptz default now(),
    updated_at timestamptz default now(),
    constraint uq_memory_key unique (profile_id, memory_key)
);

drop trigger if exists trg_memories_updated on memories;
create trigger trg_memories_updated before update on memories
for each row execute function set_updated_at();

-- ============================================================
-- ==================  BUSINESS / MLM DATA TABLES  =============
-- SCHEMA ONLY, NO PRODUCTION DATA EXISTS YET for tables 30–41.
-- These are structural definitions to support a future Business Hub.
-- Do not seed with fabricated customers, orders, sales, or payouts.
-- ============================================================

-- ============================================================
-- 30. DISTRIBUTORS
-- SCHEMA ONLY, NO PRODUCTION DATA EXISTS YET
-- ============================================================
create table if not exists distributors (
    distributor_id serial primary key,
    profile_id uuid references profiles(profile_id),
    distributor_code text unique,
    full_name text not null,
    phone text,
    email text,
    sponsor_distributor_id int references distributors(distributor_id),
    placement_leg text check (placement_leg in ('left','right','none')),
    joining_date date,
    current_rank_id int references plan_ranks(rank_id),
    kyc_status text default 'pending' check (kyc_status in ('pending','verified','rejected')),
    pan_number text,
    bank_details jsonb,
    status text default 'active' check (status in ('active','inactive','suspended','terminated')),
    created_at timestamptz default now(),
    updated_at timestamptz default now()
);

drop trigger if exists trg_distributors_updated on distributors;
create trigger trg_distributors_updated before update on distributors
for each row execute function set_updated_at();

create index if not exists idx_distributors_sponsor on distributors(sponsor_distributor_id);
create index if not exists idx_distributors_rank on distributors(current_rank_id);
create index if not exists idx_distributors_status on distributors(status);

-- ============================================================
-- 31. TEAMS
-- SCHEMA ONLY, NO PRODUCTION DATA EXISTS YET
-- ============================================================
create table if not exists teams (
    team_id serial primary key,
    team_name text not null,
    lead_distributor_id int references distributors(distributor_id),
    formed_date date,
    status text default 'active' check (status in ('active','inactive','dissolved')),
    created_at timestamptz default now(),
    updated_at timestamptz default now()
);

drop trigger if exists trg_teams_updated on teams;
create trigger trg_teams_updated before update on teams
for each row execute function set_updated_at();

-- ============================================================
-- 32. LEADERS
-- SCHEMA ONLY, NO PRODUCTION DATA EXISTS YET
-- ============================================================
create table if not exists leaders (
    leader_id serial primary key,
    distributor_id int not null unique references distributors(distributor_id) on delete cascade,
    leader_title text, -- e.g. matches plan_ranks.rank_title once promoted
    team_id int references teams(team_id),
    promoted_date date,
    mentorship_area text,
    status text default 'active' check (status in ('active','inactive')),
    created_at timestamptz default now(),
    updated_at timestamptz default now()
);

drop trigger if exists trg_leaders_updated on leaders;
create trigger trg_leaders_updated before update on leaders
for each row execute function set_updated_at();

create index if not exists idx_leaders_team on leaders(team_id);

-- ============================================================
-- 33. CUSTOMERS
-- SCHEMA ONLY, NO PRODUCTION DATA EXISTS YET
-- ============================================================
create table if not exists customers (
    customer_id serial primary key,
    profile_id uuid references profiles(profile_id),
    customer_code text unique,
    full_name text not null,
    phone text,
    email text,
    address text,
    city text,
    state text,
    pincode text,
    referred_by_distributor_id int references distributors(distributor_id),
    status text default 'active' check (status in ('active','inactive')),
    created_at timestamptz default now(),
    updated_at timestamptz default now()
);

drop trigger if exists trg_customers_updated on customers;
create trigger trg_customers_updated before update on customers
for each row execute function set_updated_at();

create index if not exists idx_customers_referred_by on customers(referred_by_distributor_id);

-- ============================================================
-- 34. ORDERS
-- SCHEMA ONLY, NO PRODUCTION DATA EXISTS YET
-- ============================================================
create table if not exists orders (
    order_id bigserial primary key,
    order_code text unique,
    customer_id int references customers(customer_id),
    distributor_id int references distributors(distributor_id),
    order_date timestamptz default now(),
    order_status text default 'pending' check (order_status in ('pending','confirmed','shipped','delivered','cancelled','returned')),
    payment_status text default 'pending' check (payment_status in ('pending','paid','failed','refunded')),
    payment_method text,
    subtotal numeric(12,2) default 0,
    discount numeric(12,2) default 0,
    tax numeric(12,2) default 0,
    shipping_fee numeric(12,2) default 0,
    total_amount numeric(12,2) default 0,
    total_bv numeric(12,2) default 0,
    total_pv numeric(12,2) default 0,
    shipping_address text,
    delivery_date date,
    created_at timestamptz default now(),
    updated_at timestamptz default now()
);

drop trigger if exists trg_orders_updated on orders;
create trigger trg_orders_updated before update on orders
for each row execute function set_updated_at();

create index if not exists idx_orders_customer on orders(customer_id);
create index if not exists idx_orders_distributor on orders(distributor_id);
create index if not exists idx_orders_status on orders(order_status);
create index if not exists idx_orders_date on orders(order_date);

-- ============================================================
-- 34a. ORDER_ITEMS
-- SCHEMA ONLY, NO PRODUCTION DATA EXISTS YET
-- Line items — normalization support for ORDERS; not separately
-- requested but required for orders to reference products.
-- ============================================================
create table if not exists order_items (
    order_item_id bigserial primary key,
    order_id bigint not null references orders(order_id) on delete cascade,
    product_id int not null references products(product_id),
    quantity int not null check (quantity > 0),
    unit_price numeric(12,2) not null,
    unit_bv numeric(12,2) default 0,
    unit_pv numeric(12,2) default 0,
    line_total numeric(12,2) not null,
    created_at timestamptz default now()
);

create index if not exists idx_order_items_order on order_items(order_id);
create index if not exists idx_order_items_product on order_items(product_id);

-- ============================================================
-- 35. SALES
-- SCHEMA ONLY, NO PRODUCTION DATA EXISTS YET
-- MLM sales-recognition record used for BV/PV/commission calculation;
-- distinct from orders (which model the e-commerce transaction).
-- order_id is nullable to allow offline/manual sales entry.
-- ============================================================
create table if not exists sales (
    sale_id bigserial primary key,
    order_id bigint references orders(order_id),
    product_id int not null references products(product_id),
    distributor_id int references distributors(distributor_id),
    customer_id int references customers(customer_id),
    sale_date date not null,
    quantity int not null check (quantity > 0),
    unit_price numeric(12,2) not null,
    total_amount numeric(12,2) not null,
    bv numeric(12,2) default 0,
    pv numeric(12,2) default 0,
    sale_type text default 'retail' check (sale_type in ('retail','self_use','repeat_order')),
    created_at timestamptz default now()
);

create index if not exists idx_sales_distributor on sales(distributor_id);
create index if not exists idx_sales_product on sales(product_id);
create index if not exists idx_sales_date on sales(sale_date);

-- ============================================================
-- 36. BV_TRANSACTIONS
-- SCHEMA ONLY, NO PRODUCTION DATA EXISTS YET
-- ============================================================
create table if not exists bv_transactions (
    bv_transaction_id bigserial primary key,
    distributor_id int not null references distributors(distributor_id),
    sale_id bigint references sales(sale_id),
    source_type text check (source_type in ('personal_purchase','team_purchase','adjustment','reversal')),
    bv_amount numeric(14,2) not null,
    leg text check (leg in ('left','right','none')),
    transaction_date date not null,
    period_week date, -- week-ending date, matches business_matching_rules weekly closing cadence
    description text,
    created_at timestamptz default now()
);

create index if not exists idx_bv_transactions_distributor on bv_transactions(distributor_id);
create index if not exists idx_bv_transactions_period on bv_transactions(period_week);

-- ============================================================
-- 37. PV_TRANSACTIONS
-- SCHEMA ONLY, NO PRODUCTION DATA EXISTS YET
-- ============================================================
create table if not exists pv_transactions (
    pv_transaction_id bigserial primary key,
    distributor_id int not null references distributors(distributor_id),
    sale_id bigint references sales(sale_id),
    source_type text check (source_type in ('personal_purchase','adjustment','reversal')),
    pv_amount numeric(14,2) not null,
    transaction_date date not null,
    period_month date, -- month-start date
    description text,
    created_at timestamptz default now()
);

create index if not exists idx_pv_transactions_distributor on pv_transactions(distributor_id);
create index if not exists idx_pv_transactions_period on pv_transactions(period_month);

-- ============================================================
-- 38. TARGETS
-- SCHEMA ONLY, NO PRODUCTION DATA EXISTS YET
-- ============================================================
create table if not exists targets (
    target_id serial primary key,
    distributor_id int not null references distributors(distributor_id),
    target_type text check (target_type in ('sales','recruitment','rank_promotion','bv','pv')),
    period_type text check (period_type in ('weekly','monthly','quarterly','yearly')),
    period_start date not null,
    period_end date not null,
    target_value numeric(14,2) not null,
    achieved_value numeric(14,2) default 0,
    status text default 'in_progress' check (status in ('in_progress','achieved','missed')),
    created_at timestamptz default now(),
    updated_at timestamptz default now(),
    constraint chk_target_period check (period_end >= period_start)
);

drop trigger if exists trg_targets_updated on targets;
create trigger trg_targets_updated before update on targets
for each row execute function set_updated_at();

create index if not exists idx_targets_distributor on targets(distributor_id);
create index if not exists idx_targets_period on targets(period_start, period_end);

-- ============================================================
-- 39. RANK_HISTORY
-- SCHEMA ONLY, NO PRODUCTION DATA EXISTS YET
-- ============================================================
create table if not exists rank_history (
    rank_history_id bigserial primary key,
    distributor_id int not null references distributors(distributor_id),
    rank_id int not null references plan_ranks(rank_id),
    achieved_date date not null,
    qualification_period text,
    bv_at_achievement numeric(14,2),
    is_current boolean default true,
    created_at timestamptz default now()
);

create unique index if not exists uq_rank_history_current on rank_history(distributor_id) where is_current;
create index if not exists idx_rank_history_distributor on rank_history(distributor_id);

-- ============================================================
-- 40. SUPPORT_TICKETS
-- SCHEMA ONLY, NO PRODUCTION DATA EXISTS YET
-- ============================================================
create table if not exists support_tickets (
    ticket_id bigserial primary key,
    ticket_code text unique,
    profile_id uuid references profiles(profile_id),
    customer_id int references customers(customer_id),
    distributor_id int references distributors(distributor_id),
    category text check (category in ('refund','replacement','cancellation','shipping','product_issue','account','payment','other')),
    subject text not null,
    description text,
    priority text default 'medium' check (priority in ('low','medium','high','urgent')),
    status text default 'open' check (status in ('open','in_progress','resolved','closed','escalated')),
    assigned_to uuid references profiles(profile_id),
    resolution text,
    opened_at timestamptz default now(),
    resolved_at timestamptz,
    sla_due_at timestamptz,
    created_at timestamptz default now(),
    updated_at timestamptz default now()
);

drop trigger if exists trg_support_tickets_updated on support_tickets;
create trigger trg_support_tickets_updated before update on support_tickets
for each row execute function set_updated_at();

create index if not exists idx_support_tickets_status on support_tickets(status);
create index if not exists idx_support_tickets_customer on support_tickets(customer_id);
create index if not exists idx_support_tickets_distributor on support_tickets(distributor_id);

-- ============================================================
-- END OF EXTENDED SCHEMA
-- Tables added: roles, profiles, user_roles, product_variants,
-- product_prices, product_ingredients, product_benefits,
-- company_documents, policies, compensation_rules, training_content,
-- knowledge_sources, knowledge_documents, conversations, messages,
-- memories, distributors, teams, leaders, customers, orders,
-- order_items, sales, bv_transactions, pv_transactions, targets,
-- rank_history, support_tickets.
-- ============================================================
