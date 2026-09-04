# Dayjoy Knowledge Base — Outdated Files Report

Generated: 2026-08-09. Based on content inspection (row counts, columns, field completeness), not filename/date alone.

## Two separate pipelines exist — don't confuse "outdated within a pipeline" with "conflicting between pipelines"

Content inspection shows the knowledge base was actually built by **two different generation tracks** that never merged:

**Pipeline A — "Governance/Phase" track** (small, rigorous, tracks confidence/approval per record):
```
phase1-baseline  →  phase2-gap-register  →  phase3  →  phase4-gap-register(-final)  →  phase9-qa-test-sheet  →  release-manifest / dayjoy-final-release.zip
                                                                                       ↓
                          canonical-product-master → canonical-product-master(2)/sql-ready → dayjoy-canonical-product-master-final  [170 rows, verified pricing]
                          dayjoy-rag-chunks → dayjoy-rag-chunks-final                        [2,197 → 2,242 rows]
                          metadata-registry → dayjoy-metadata-registry-final                 [2,197 → 2,242 rows]
                          dayjoy-intent-master-final                                          [1,527 rows]
```
Within this pipeline, supersession is clear and safe to apply: the `-final` / higher-phase-number / `some updated file/`-folder copy (dated 2026-08-09, i.e. today, the most recent activity in the whole KB) is newer and more complete than the same-named file bundled inside `artifacts-3of3.zip` (e.g. `dayjoy-rag-chunks-final.csv` at 2,242 rows supersedes `dayjoy-rag-chunks.csv` at 2,197 rows — same schema, later file has more rows and no unfilled confidence fields).

**Pipeline B — "Comprehensive dataset" track** (large, less governance metadata, more content per record):
```
dayjoy_products_master.csv        [170 rows, 20 cols, has real filled mrp/dp/bv/pv + brand/manufacturer/country]
dayjoy_rag_chunks_dataset.csv     [4,000 rows, Q&A-structured]
dayjoy_master_intent_dataset_updated.csv / Dayjoy_Master_Intent_Dataset.csv  [4,000 rows]
dayjoy_unified_rag_corpus.*       [multi-format exports of a unified corpus]
dayjoy_postgresql_ready_corpus.*  [SQL-ready export]
```
This track culminated in `dayjoy_postgresql_ready_corpus` / `dayjoy_unified_rag_corpus` as its "final" output, exported to CSV/JSON/SQL/XLSX/MD simultaneously (5 formats × same data, verified as non-duplicate representations of the same content — normal multi-format export, not redundant content).

**Pipeline A and Pipeline B do not supersede each other** — see `DUPLICATE_REPORT.md` items 1–3. They must be reconciled by a human decision (likely: merge B's descriptive richness with A's verified pricing/governance), not treated as one being "outdated."

## Safe-to-archive as outdated (same pipeline, clearly superseded)

| Outdated file | Superseded by | Evidence |
|---|---|---|
| `canonical-product-master.csv` (18 cols, no pricing) | `canonical-product-master (2).csv` / `-sql-ready.csv` (18 cols, pricing filled) | Same schema, later version has bv/mrp/dp populated |
| `canonical-product-master (2).csv` / `-sql-ready.csv` (18 cols) | `dayjoy-canonical-product-master-final.csv` (20 cols, adds confidence tracking, `missing_fields_count=0`) | Same 170 SKUs, strictly more complete |
| `structured_product_master.csv` (33 cols) | `canonical-product-master-final.csv` (41 cols, same extraction + 8 more metadata cols) | Identical row-for-row content pattern, later file is a superset |
| `dayjoy-rag-chunks.csv` (2,197 rows) | `dayjoy-rag-chunks-final.csv` (2,242 rows) | Same schema, later file has 45 more chunks |
| `metadata-registry.csv` (2,197 rows) | `dayjoy-metadata-registry-final.csv` (2,242 rows) | Companion file to rag-chunks, same pattern |
| `knowledge-gap-register.csv` (826 rows, phase2) | `phase4-gap-register(-final).csv` → later `gap-register-rerun.csv` (1,360 rows) | Sequential phase numbering; **verify** `unresolved_gaps.csv` (1,245 rows) isn't simply a filtered subset before archiving it too — flagged in Duplicate Report, not auto-resolved |
| `dayjoy_master_intent_dataset_updated (2).*` (all formats) | Identical to `dayjoy_master_intent_dataset_updated.*` (non-suffixed) — exact hash match | Pure re-bundling artifact |
| All `(2)`, `(3)` suffixed files in `artifacts-3of3.zip` | Their non-suffixed twins | Exact hash matches, see Duplicate Report |
| Every zip nested inside another zip (`Dayjoy_AI_Assist_Database_Package.zip` vs. `_v2` vs `_production` vs `_final`) | The `_final` variant, if content-verified superset | **Needs one more check**: sizes differ (111KB → 267KB → 549KB → 1.1MB), suggesting each added more tables — worth a quick diff pass before archiving the earlier three, since "later name" isn't proof of "superset" on its own |

## Documents that are NOT outdated — separate content, keep both

- `Dayjoy AI Ecosystem Enterprise Knowledge Repository & Systems Architecture.docx` and `Dayjoy AI Ecosystem Master Knowledge Base Generation.docx` (top-level) — these appear to be the source documents that the `artifacts.zip` → `02_System_Architecture *.md` / `03_Database_Design *.md` / `04_API_Backend_Architecture *.md` (32 files) were generated from. Architecture/planning docs, not data — belongs in a separate governance/architecture folder, not archived.
- `dayjoy_product_index_updated.csv` (1,106 rows) — this is **not** a product master version at all, it's a recommendation-chart index (Product × Health-Condition → Page mapping). Mis-groupable by name; keep as its own dataset under recommendation/relationships, not as a product-master candidate.
- `Dayjoy_Products_Catalog.csv` (86 rows, different product names) — see Duplicate Report item 6. Not confirmed as outdated; could be a different catalog.

## What still needs a byte-level diff before final archival decision

The `Dayjoy_AI_Assist_Database_Package*.zip` family (base → `_v2` → `_production` → `_final`) and the two release zips (`dayjoy-release-package.zip` 30KB vs `dayjoy-final-release.zip` 8.5MB — very different sizes, likely different scope, not versions of the same thing) have not been diffed table-by-table yet. Recommend a follow-up pass before physically archiving anything from this family.
