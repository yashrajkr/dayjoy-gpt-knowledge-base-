# Dayjoy Knowledge Base — Duplicate Report

Generated: 2026-08-09 | Method: SHA-256 content hashing of every file, including full recursive extraction of all ZIPs (nested ZIPs included, up to 8 levels deep).

## Headline numbers

| Metric | Count |
|---|---|
| Total file records analyzed (originals + everything inside every ZIP, including nested ZIPs) | 1,803 |
| Files with genuinely unique content (by SHA-256) | 440 |
| Files that are byte-for-byte duplicates of another file | 1,696 (94% of records) |
| Distinct duplicate groups (2+ identical files) | 333 |
| Disk space consumed by redundant exact copies | ~506.6 MB |
| Top-level ZIP files | 6 (3 `artifacts-Nof3.zip`, 3 inside `some updated file/`) |
| Total ZIP files found once you unpack everything (including ZIPs nested inside ZIPs) | 20+ |

## Root cause: fractal ZIP nesting

This is the single biggest driver of duplication. The knowledge base was built by repeatedly bundling "everything so far" into a new ZIP and re-uploading it, so each new ZIP contains the previous ZIP(s) whole, plus new material:

```
artifacts-1of3.zip
 └─ artifacts.zip                         (an earlier full bundle)
 └─ Dayjoy_Complete_Verified_Data.zip      (an even earlier bundle)
 └─ artifacts-2of3.zip                     (nested copy — see below)
      └─ artifacts-3of3.zip                (nested copy — see below)
      └─ Dayjoy_AI_Assist_Database_Package.zip (+ _v2, _production, _final variants)
      └─ dayjoy-phase1-baseline.zip
      └─ dayjoy-phase2-gap-register.zip
      └─ dayjoy_postgresql_rag_bundle.zip
      └─ dayjoy_master_everything_updated.zip
      └─ dayjoy_complete_all_updated.zip
      └─ dayjoy_ai_memory_dataset_bundle.zip / _sharegpt_bundle.zip
      └─ dayjoy_image_metadata_bundle.zip / _master_bundle.zip
artifacts-2of3.zip   (also exists standalone at top level — 100MB vs. the 82.7MB copy nested inside artifacts-1of3.zip: NOT identical, the standalone one is a later/larger revision)
artifacts-3of3.zip   (also exists standalone — 17.55MB vs. 17.57MB nested copy: near-identical, minor diff)
```

Practical effect: a file like `dayjoy_products_master.csv` was found **34 separate times** across the archive tree — it's the same 38,100-byte file every time, just re-packaged into a new bundle over and over. This pattern repeats for dozens of files (see table below).

## Most-duplicated files (top 15, by exact copy count)

| File | Copies found | Size |
|---|---|---|
| dayjoy_products_master.csv | 34 | 38,100 B |
| dayjoy_database_schema.sql | 33 | 12,341 B |
| dayjoy_plan_ranks_rewards.csv | 33 | 3,404 B |
| dayjoy_brands.csv | 33 | 282 B |
| dayjoy_plan_faq_knowledge.csv | 33 | 4,221 B |
| dayjoy_categories.csv | 33 | 419 B |
| dayjoy_all_extracted_knowledge_master.csv | 32 | 11,555 B |
| dayjoy_extraction_confirmation.txt | 32 | 1,033 B |
| dayjoy_recommendation_summary.csv | 32 | 126 B |
| dayjoy_recommendation_chart_updated.csv | 32 | 76,469 B |
| dayjoy_project_status.md | 32 | 902 B |
| dayjoy_business_matching_matrix.csv | 32 | 1,236 B |
| dayjoy_product_index_updated.csv | 32 | 82,252 B |
| dayjoy_recommendation_chart_updated.xlsx | 32 | 61,809 B |
| dayjoy_product_relationships.csv | 28 | 30,976 B |

Full group-by-group listing (all 333 groups) is in `01_AUDIT/file_inventory.csv`, column `duplicate_group`.

## The `(1)`, `(2)`, `(3)` filename pattern

Every file in the `some updated file/` folder that has a `(1)` suffix is a **verified byte-identical duplicate** of its non-suffixed twin — these are simple re-download artifacts (e.g. `dayjoy-canonical-product-master-final (1).csv` == `dayjoy-canonical-product-master-final.csv`, same SHA-256). Same story for `(2)`/`(3)` suffixes inside `artifacts-3of3.zip` (e.g. `canonical-product-master (2).csv` == `canonical-product-master (3).csv` == `canonical-product-master-sql-ready.csv`, all one hash, 17 copies total). **Recommendation: archive all suffixed copies, keep one representative per hash.**

## Semantic / near-duplicates (different hash, same information) — NOT auto-resolved

These are NOT byte-identical, so hashing alone doesn't catch them — they need human judgement per your rule against silently resolving conflicts. Flagged for `PROPOSED_STRUCTURE.md` / your review:

1. **Two parallel "final" product masters that disagree**, not just in schema but in what they claim to know:
   - `dayjoy-canonical-product-master-final.csv` (170 rows, 20 cols) — has verified pricing (mrp/dp/bv/pv filled), governance fields (`approval_status=approved`, `pricing_confidence=verified_price_list`, `risk_level=low`), but **no descriptive content** (no ingredients/benefits/usage/dosage).
   - `canonical-product-master-final.csv` (170 rows, 41 cols) — rich descriptive content (ingredients, benefits, usage, dosage, warnings, certifications, FAQs, related products) but **pricing is entirely blank** (`status=needs_source_enrichment`, `risk_level=high`).
   - These look like they should be **merged** (one has the numbers, the other has the words), but neither is a superset of the other. Do not pick one and discard the other.

2. **Two different-sized RAG chunk datasets with different schemas**:
   - `dayjoy-rag-chunks-final (1).csv` / metadata-registry pairing: 2,242 rows, 13 cols, structured around `chunk_id/product_code/role_scope/risk_level` (governance-oriented).
   - `dayjoy_rag_chunks_dataset.csv`: 4,000 rows, 20 cols, structured around `question/answer/intent_category` (Q&A-oriented).
   - These appear to be two different pipelines' output, not versions of each other.

3. **Two different-sized intent datasets**, same pattern: `dayjoy-intent-master-final.csv` (1,527 rows, governance schema) vs. `Dayjoy_Master_Intent_Dataset.csv` / `dayjoy_master_intent_dataset_updated.*` (4,000 rows, simpler schema).

4. **Three different gap-register row counts** that are NOT simple supersession: `knowledge-gap-register.csv` (826 rows) → `unresolved_gaps.csv` (1,245 rows) → `gap-register-rerun.csv` (1,360 rows). Could be sequential reruns, or `unresolved_gaps` could be a filtered subset. Needs verification before treating any one as canonical.

5. **Two different-shaped release manifests**: `RELEASE_MANIFEST.csv` (15 rows, `folder/file/exists`) vs. `release-manifest.csv` (9 rows, `file/purpose/included`) — different structure, from different packaging attempts, not duplicates of each other.

6. **Possible two distinct product catalogs, not one catalog in two formats**: `dayjoy_products_master.csv` / the "final" masters all describe a 170-SKU line coded `DJP1000–DJP1169` (food/wellness items under sub-brands "Aayushmaan / YumDum / Total Joy"). `Dayjoy_Products_Catalog.csv` (86 rows) describes differently-named products ("Asthprash", "Kidney Kawach", "Curind") under different sub-brand names, with no DJP codes. **This needs your confirmation**: are these the same products under different naming, a different (older or newer) product line, or a genuinely separate catalog that also needs to be represented in the canonical product master?

## What this means for Step 4 (Never Delete)

Nothing has been deleted. All 1,803 file records are still fully intact in their original locations. This report only classifies; the actual archive move happens in the execution phase, after you approve `PROPOSED_STRUCTURE.md`.
