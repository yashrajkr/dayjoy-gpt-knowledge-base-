-- ============================================================
-- DAYJOY AI ASSIST — PRODUCTION DATABASE SCHEMA (PostgreSQL / Supabase)
-- Generated from verified source documents:
--   - India-BV-Price-May-2026.pdf (effective 2026-05-05)
--   - Dayjoy-Product-Brochure-English-July2026.pdf
--   - DayjoyProduct_RecommandationChart (cleaned)
--   - Dayjoy-GrowthX-Plan-Presentation
-- NOTE: This schema was generated WITHOUT live access to the existing
-- Supabase project or GitHub repo (yashrajkr/Dayjoy-AI-Assist) because
-- no schema export, SQL dump, or repository files were supplied.
-- Review column names against your existing tables before running.
-- Run this in a STAGING project first.
-- ============================================================

-- Extensions
create extension if not exists "uuid-ossp";
create extension if not exists pg_trgm;
create extension if not exists vector; -- for RAG embeddings (pgvector)

-- ============================================================
-- 1. CATEGORIES
-- ============================================================
create table if not exists categories (
    category_id serial primary key,
    category_name text not null unique,
    category_slug text not null unique,
    parent_category_id int references categories(category_id),
    description text,
    created_at timestamptz default now(),
    updated_at timestamptz default now()
);

-- ============================================================
-- 2. BRANDS / SUB-BRANDS
-- ============================================================
create table if not exists brands (
    brand_id serial primary key,
    brand_name text not null unique,
    brand_slug text not null unique,
    brand_description text,
    parent_company text default 'Adila Biotech / Dayjoy Marketing Pvt. Ltd.',
    created_at timestamptz default now()
);

-- ============================================================
-- 3. PRODUCTS (core master table)
-- ============================================================
create table if not exists products (
    product_id serial primary key,
    product_uuid uuid default uuid_generate_v4() unique,
    product_code text unique,
    sku text unique,
    barcode text unique,
    product_name text not null,
    base_name text,
    slug text unique,
    pack_size text,
    weight text,
    variant text,
    category_id int references categories(category_id),
    brand_id int references brands(brand_id),
    mrp numeric(12,2) not null check (mrp >= 0),
    dp numeric(12,2) not null check (dp >= 0),
    bv numeric(12,2) default 0 check (bv >= 0),
    pv numeric(12,2) default 0 check (pv >= 0),
    currency text default 'INR',
    price_effective_date date,
    manufacturer text,
    country text default 'India',
    status text default 'active' check (status in ('active','inactive','discontinued','out_of_stock','coming_soon')),
    availability text default 'in_stock' check (availability in ('in_stock','out_of_stock','pre_order','discontinued')),
    launch_date date,
    expiry_months int,
    shelf_life_text text,
    target_customer text,
    age_group text,
    gender_suitability text default 'unisex',
    ingredients text,
    nutrition_facts jsonb,
    benefits text,
    key_features text,
    usage_instructions text,
    dosage text,
    storage_instructions text,
    warnings text,
    contraindications text,
    side_effects text,
    fssai_number text,
    gmp_certified boolean default true,
    iso_certified boolean default true,
    who_gmp_certified boolean default false,
    other_certifications text,
    seo_title text,
    seo_description text,
    meta_keywords text,
    search_keywords text,
    product_tags text[],
    last_updated_by text,
    created_at timestamptz default now(),
    updated_at timestamptz default now()
);

create index if not exists idx_products_category on products(category_id);
create index if not exists idx_products_brand on products(brand_id);
create index if not exists idx_products_status on products(status);
create index if not exists idx_products_name_trgm on products using gin (product_name gin_trgm_ops);
create index if not exists idx_products_search_keywords_trgm on products using gin (search_keywords gin_trgm_ops);
create index if not exists idx_products_tags on products using gin (product_tags);

-- ============================================================
-- 4. PRODUCT IMAGES
-- ============================================================
create table if not exists product_images (
    image_id serial primary key,
    product_id int not null references products(product_id) on delete cascade,
    image_type text not null check (image_type in ('primary','thumbnail','gallery','high_quality')),
    image_url text not null,
    webp_url text,
    alt_text text,
    caption text,
    sort_order int default 0,
    is_lazy_loaded boolean default true,
    is_compressed boolean default false,
    width int,
    height int,
    created_at timestamptz default now()
);

create index if not exists idx_product_images_product on product_images(product_id);
create unique index if not exists uq_product_primary_image on product_images(product_id) where image_type = 'primary';

-- ============================================================
-- 5. PRODUCT FAQs
-- ============================================================
create table if not exists product_faqs (
    faq_id serial primary key,
    product_id int not null references products(product_id) on delete cascade,
    question text not null,
    answer text not null,
    faq_category text,
    sort_order int default 0,
    source text,
    created_at timestamptz default now(),
    updated_at timestamptz default now()
);

create index if not exists idx_faqs_product on product_faqs(product_id);

-- ============================================================
-- 6. PRODUCT RELATIONSHIPS  (the missing table you asked for)
-- ============================================================
create table if not exists product_relationships (
    relationship_id serial primary key,
    product_a_id int not null references products(product_id) on delete cascade,
    product_b_id int not null references products(product_id) on delete cascade,
    relationship_type text not null check (relationship_type in (
        'similar_product','related_product','alternative_product',
        'frequently_bought_together','recommended_combination',
        'premium_upgrade','budget_option','cross_sell','upsell',
        'budget_to_premium_variant'
    )),
    co_occurrence_count int,
    confidence_score numeric(4,3) default 0.5,
    source text,
    created_at timestamptz default now(),
    constraint uq_relationship unique (product_a_id, product_b_id, relationship_type),
    constraint no_self_relationship check (product_a_id <> product_b_id)
);

create index if not exists idx_rel_product_a on product_relationships(product_a_id);
create index if not exists idx_rel_product_b on product_relationships(product_b_id);
create index if not exists idx_rel_type on product_relationships(relationship_type);

-- ============================================================
-- 7. SYMPTOM / CONDITION -> PRODUCT RECOMMENDATION MAP
-- ============================================================
create table if not exists condition_recommendations (
    recommendation_id serial primary key,
    category text,
    condition_name text not null,
    subcondition text,
    product_id_1 int references products(product_id),
    product_id_2 int references products(product_id),
    product_id_3 int references products(product_id),
    product_id_4 int references products(product_id),
    usage_notes text,
    priority text default 'medium' check (priority in ('high','medium','low')),
    confidence text default 'medium' check (confidence in ('high','medium','low')),
    source_page int,
    original_text_snippet text,
    created_at timestamptz default now()
);

create index if not exists idx_cond_rec_condition on condition_recommendations using gin (condition_name gin_trgm_ops);
create index if not exists idx_cond_rec_category on condition_recommendations(category);

-- ============================================================
-- 8. GROWTHX PLAN — RANKS / CLUBS
-- ============================================================
create table if not exists plan_ranks (
    rank_id serial primary key,
    club_no int not null unique,
    club_name text not null,
    rank_title text not null,
    bv_matching_criteria text,
    business_matching_incentive_rs numeric(14,2),
    mentorship_incentive_rs numeric(14,2),
    lifetime_reward_rs numeric(14,2),
    reward_description text,
    total_income_base_rs numeric(14,2),
    source_page int,
    created_at timestamptz default now()
);

-- ============================================================
-- 9. BUSINESS MATCHING INCENTIVE MATRIX
-- ============================================================
create table if not exists business_matching_rules (
    rule_id serial primary key,
    activation_level text not null,
    weekly_max_threshold_rs numeric(14,2),
    stage text not null,
    ratio_type text,
    bv_ratio text,
    income_rs numeric(14,2),
    weekly_closing text default 'Every Wednesday',
    weekly_payout text default 'Every Friday',
    source_page int,
    created_at timestamptz default now()
);

-- ============================================================
-- 10. PLAN FAQ / KNOWLEDGE (GrowthX plan Q&A)
-- ============================================================
create table if not exists plan_faqs (
    plan_faq_id serial primary key,
    topic_key text,
    question text not null,
    answer text not null,
    source_file text,
    source_pages text,
    created_at timestamptz default now()
);

-- ============================================================
-- 11. RAG KNOWLEDGE CHUNKS (with pgvector embeddings)
-- ============================================================
create table if not exists knowledge_chunks (
    chunk_id uuid primary key default uuid_generate_v4(),
    product_id int references products(product_id),
    chunk_type text check (chunk_type in ('product','faq','plan','recommendation','company_info')),
    chunk_text text not null,
    metadata jsonb,
    tags text[],
    source_file text,
    source_page text,
    confidence_score numeric(4,3) default 0.8,
    embedding vector(1536),
    created_at timestamptz default now(),
    updated_at timestamptz default now()
);

create index if not exists idx_chunks_product on knowledge_chunks(product_id);
create index if not exists idx_chunks_type on knowledge_chunks(chunk_type);
create index if not exists idx_chunks_embedding on knowledge_chunks using ivfflat (embedding vector_cosine_ops) with (lists = 100);

-- ============================================================
-- 12. AUDIT LOG (admin panel change tracking)
-- ============================================================
create table if not exists audit_log (
    log_id bigserial primary key,
    table_name text not null,
    record_id text not null,
    action text not null check (action in ('insert','update','delete')),
    changed_by text,
    old_data jsonb,
    new_data jsonb,
    changed_at timestamptz default now()
);

create index if not exists idx_audit_table_record on audit_log(table_name, record_id);

-- ============================================================
-- 13. UPDATED_AT AUTO-TRIGGER
-- ============================================================
create or replace function set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_products_updated on products;
create trigger trg_products_updated before update on products
for each row execute function set_updated_at();

drop trigger if exists trg_faqs_updated on product_faqs;
create trigger trg_faqs_updated before update on product_faqs
for each row execute function set_updated_at();

drop trigger if exists trg_chunks_updated on knowledge_chunks;
create trigger trg_chunks_updated before update on knowledge_chunks
for each row execute function set_updated_at();

-- ============================================================
-- END OF SCHEMA
-- ============================================================
