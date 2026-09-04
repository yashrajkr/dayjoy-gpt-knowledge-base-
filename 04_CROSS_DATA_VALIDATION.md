# Cross-Data Validation

Checks run across Source Registry, Product Master, Pricing Master, FAQ, RAG, Metadata Registry, SQL, and Images. Builds on the three phase audits (`01_SOURCE_REGISTRY_AUDIT.md`, `02_PRODUCT_MASTER_AUDIT.md`, `03_PRICING_MASTER_AUDIT.md`) rather than re-deriving their findings — this document adds the checks that only make sense *between* files. All numbers below were computed directly against the repository on 2026-08-09. Nothing was modified.

## Summary table

| Check | Result | Severity |
|---|---|---|
| Orphan product IDs (FAQ → product master) | 0/1,884 by `sku`; `product_id` field itself is not the right join key (see below) | Low (naming confusion, not data loss) |
| Orphan SKUs (RAG → product master) | 0/2,224 rows with a sku set | None |
| Orphan SKUs (Intents → product master) | 0/1,122 rows with a sku set | None |
| Missing source IDs (product master → source registry) | No formal `source_registry.csv` to check against (Phase 1 finding) — citations point to real files but one filename citation is wrong (see below) | Medium |
| Missing image IDs | `image_ids` column 0/170 populated in product master; underlying metadata file 90/120 (75%) broken paths | High |
| Missing FAQ IDs | `faq_ids` column 0/170 populated in product master, despite FAQ→product linkage being 100% clean in the reverse direction | Medium |
| Duplicate products | 0 exact duplicates; 34 near-identical name pairs, all verified as legitimate distinct SKUs | None |
| Duplicate SKUs | 0 (170/170 unique) | None |
| Conflicting prices | 0 — mrp/dp/bv agree 100% between the standalone pricing file and the product master where comparable | None |
| Outdated prices | No price-history mechanism exists to even define "outdated" — single current price only, everywhere | Medium (capability gap, not a live defect) |
| Missing pack sizes | 0/170 — pack_size populated on every row | None |
| Conflicting product names | 0 — no two rows share a name+pack_size | None |
| Broken relationships | `similar_product_ids`/`related_product_ids` 0/170 populated in product master; a separate relationships file exists but isn't wired in (see below) | Medium |
| Inconsistent categories | 12 categories, all internally consistent (used identically across product master, safety classes) | None |
| Stale data | `source_version`/`last_verified`/`effective_from` are a single frozen date (2026-05-05) across all 170 rows — not "stale" exactly, but also not distinguishing anything | Low |
| Missing verification status | Present everywhere it's expected, but uniform (rubber-stamped) rather than differentiated — already flagged in Phase 2 audit | Medium |

## New findings from cross-file checks (not covered by the phase audits individually)

### 1. `product_id` means two different things in two different files
`01_CANONICAL/faq/dayjoy_faq_combined_canonical.csv` has a `product_id` column that is a plain row-sequence integer (1, 2, 3…), unrelated to `01_CANONICAL/products/dayjoy_product_master_canonical.csv`'s `product_id`, which is the `DJP1000`-style code. The FAQ file's `product_code` column (not `product_id`) is what actually matches the product master's `product_id` (verified: 0/1,884 mismatches). Anyone joining these two files on `product_id` by name alone, without checking the actual values, would get a silent, fully-populated, completely wrong join — this is worse than an orphan, because it wouldn't visibly fail. `sku` is the safe join key between these two files (also 0 mismatches) and should be preferred over `product_id`/`product_code` naming.

### 2. RAG and Intents are clean; the reliability problem is concentrated in the product master's own unpopulated columns
`04_RAG/chunks/dayjoy_rag_chunks_CANONICAL.csv` (2,242 rows, 2,224 with a `sku` set) and `03_AI_DATASETS/intents/dayjoy_intents_CANONICAL.csv` (1,531 rows, 1,122 with a `sku` set) both have **zero orphan SKUs** against the product master — every sku they reference is real. This is a genuinely clean result and worth stating plainly rather than assuming a problem exists everywhere just because one was found elsewhere. The relationship-integrity problems documented in Phase 2 (`faq_ids`, `image_ids`, `similar_product_ids`, `related_product_ids` all empty) are specific to the product master's own forward-pointing columns, not a repo-wide linkage failure.

### 2b. A relationships file exists and is unused
`02_RELATIONSHIPS/product_relationships/dayjoy_product_relationships.csv` exists but the product master's `similar_product_ids`/`related_product_ids` columns don't draw from it. This file was flagged as out-of-scope by the Phase 2 audit; confirming here that it is present and structurally available for a future backfill, but not currently wired into the product master.

### 3. Safety classification has perfect 1:1 coverage
`08_GOVERNANCE/safety/dayjoy_product_safety_classes.csv` (170 rows) has zero orphan SKUs in either direction against the product master — every product has exactly one safety classification and every safety row maps to a real product. This is the cleanest cross-file relationship in the repository.

### 4. Image metadata is the single worst-linked file in the repository
126 real image files exist on disk (`06_IMAGES/products/`), but `06_IMAGES/metadata/dayjoy_image_metadata_CANONICAL.csv` only has 120 rows, and of those, only 30 (25%) resolve to an actual file (Phase 2 finding, confirmed here at the cross-file level: this means **no downstream file** — not the product master, not RAG, not any future retrieval layer — can currently trust `image_ids`/image paths without independently re-deriving them from the real files on disk).

### 5. Pricing conflict-tracking is inconsistent in shape across the repo
`01_CANONICAL/compensation/dayjoy_compensation_conflicts.csv` uses a structured `status=CONFLICT_UNRESOLVED` pattern. `01_CANONICAL/products/catalog86_pricing_crosscheck_conflicts.csv` (the pricing-side equivalent) uses a narrower schema with no `status` column at all (Phase 3 finding). A cross-repo consumer looking for "all unresolved conflicts" by filtering on `status` would silently miss the pricing conflicts. This is a consistency gap between two conflict-tracking files that should share a schema.

### 6. SQL schema tables vs. actual canonical files — mostly aligned, one orphaned table
`05_SQL/schema/dayjoy_database_schema.sql` defines 12 tables: `categories, brands, products, product_images, product_faqs, product_relationships, condition_recommendations, plan_ranks, business_matching_rules, plan_faqs, knowledge_chunks, audit_log`. All of these have a plausible canonical-file counterpart in the repo (products↔product master, product_faqs↔FAQ file, plan_ranks↔compensation ranks, knowledge_chunks↔RAG chunks, etc.) except `product_relationships`, which maps to `02_RELATIONSHIPS/product_relationships/dayjoy_product_relationships.csv` — consistent with finding 2b that this file exists but isn't referenced from the product master itself. The supplement schema (`dayjoy_postgresql_schema_supplement.sql`) defines one additional table, `dayjoy_unified_rag_corpus` — this was already flagged and resolved by recommendation in the prior T015 reconciliation (use `knowledge_chunks`, not this table, since the RAG-pipeline audit found the corpus it would hold is redundant). No new issue here, just confirming the earlier resolution still holds.

### 7. Stale-data check
Every "verified/effective" date field across every canonical file checked (`source_version`, `last_verified`, `effective_from`, pricing `effective_date`) is frozen at a single value: `2026-05-05`. Nothing in the repository is chronologically stale relative to that date, but the uniformity also means the fields carry no information about *when* something was last actually re-checked versus just carried forward from the original ingestion — a soft staleness risk if this date is never updated as time passes.

## What's genuinely NOT a problem (stated explicitly, since audits should say what's fine too)

- No duplicate product_ids or SKUs anywhere in any file checked.
- No conflicting prices between any two files that both carry a "current price" (mrp/dp/bv all agree where comparable).
- No pack-size gaps.
- No category-naming inconsistency.
- FAQ, RAG, and Intents all have clean (zero-orphan) SKU-based linkage to the product master — the earlier concern that multiple pipelines might disagree about which SKUs exist is not borne out by the data.

## Verdict inputs for Step 5

This cross-validation does not change any individual phase's verdict — all three remain **READY WITH FIXES** as stated in their own audits. It does surface two new, repo-wide (not phase-specific) issues that should be tracked in `06_REMAINING_GAPS.csv`: the `product_id` naming collision between FAQ and product master (finding 1), and the conflict-tracking schema inconsistency (finding 5).
