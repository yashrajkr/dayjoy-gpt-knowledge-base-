-- ============================================================
-- MIGRATION 001 — INITIAL EXTENDED SCHEMA
-- ============================================================
-- Purpose: apply the extension schema (identity/auth, catalog
-- extensions, company/policy/training/knowledge tables, and the
-- MLM business-data tables) on top of the already-reconciled
-- canonical schema.
--
-- Prerequisites (must already exist in the target database):
--   1. 05_SQL/schema/dayjoy_database_schema.sql
--      (categories, brands, products, product_images, product_faqs,
--       product_relationships, condition_recommendations, plan_ranks,
--       business_matching_rules, plan_faqs, knowledge_chunks, audit_log)
--
-- This migration is idempotent (every statement uses IF NOT EXISTS /
-- OR REPLACE / DROP ... IF EXISTS) and can be safely re-run.
--
-- Rollback: see 001_initial_extended_schema_rollback.sql (not yet
-- created — write DROP TABLE IF EXISTS ... CASCADE for the table list
-- at the bottom of this file, in reverse dependency order, before
-- running in a real environment).
-- ============================================================

begin;

-- 1. Extension schema (tables, triggers, exclusion constraint)
\i '../schema/dayjoy_full_production_schema.sql'

-- 2. Indexes consolidated for the new tables
\i '../schema/indexes.sql'

-- 3. Row Level Security policy stubs (DRAFT — see file header)
\i '../schema/rls_policies.sql'

commit;

-- ============================================================
-- Tables created by this migration:
--   roles, profiles, user_roles, product_variants, product_prices,
--   product_ingredients, product_benefits, company_documents,
--   policies, compensation_rules, training_content, knowledge_sources,
--   knowledge_documents, conversations, messages, memories,
--   distributors, teams, leaders, customers, orders, order_items,
--   sales, bv_transactions, pv_transactions, targets, rank_history,
--   support_tickets.
--
-- NO ROWS ARE INSERTED BY THIS MIGRATION. Business-data tables
-- (customers, distributors, leaders, teams, orders, order_items,
-- sales, bv_transactions, pv_transactions, targets, rank_history,
-- support_tickets) remain empty — schema only, per project policy of
-- never fabricating business/transaction data.
-- ============================================================
