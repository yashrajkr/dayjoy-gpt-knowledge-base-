# Dayjoy Knowledge Base — Proposed Final Structure

Generated: 2026-08-09. **Nothing has been moved yet. This is a proposal for your approval.** Once you approve (with any corrections), I execute: move files into this structure, archive non-canonical copies into `_archive/` with a manifest, and produce the final gap report.

## Before structure: three decisions I need from you first

The audit found two things that can't be auto-resolved without your input — building the structure around a guess would just create a new layer of confusion. Everything else below can proceed on my recommendation.

**Decision 1 — Product catalog identity.** Is `Dayjoy_Products_Catalog.csv` (86 items: "Asthprash", "Kidney Kawach", "Curind"...) the same 170-SKU line as `DJP1000–DJP1169` under different sub-brand names, an older/different product line, or a separate catalog that needs its own place in the product master?

**Decision 2 — Which pipeline is authoritative for product master / intent / RAG.** Pipeline A (governance-tracked, verified pricing, 170/1,527/2,242 rows, thinner content) vs. Pipeline B (comprehensive, 170/4,000/4,000 rows, richer content, no confidence tracking) — see `DUPLICATE_REPORT.md`. My recommendation: **merge them** (Pipeline A's verified pricing + governance fields as the source of truth for facts, Pipeline B's descriptive content layered on top, keeping both sources traceable per-field) rather than picking one and discarding the other's unique information. Confirm this approach or tell me otherwise.

**Decision 3 — Gap register lineage.** Is `unresolved_gaps.csv` (1,245 rows) a filtered subset of `gap-register-rerun.csv` (1,360 rows), or an independent list? Determines whether it's archived as redundant or kept as a live "still open" tracker.

## Proposed folder structure

Adapted from your spec — kept your 00–09/99 skeleton, added two folders your original spec didn't have room for (`00_PROJECT_ARCHITECTURE/` for the engineering docs that turned up, and made `08_GOVERNANCE/answer_policy` etc. reflect what actually exists rather than empty scaffolding):

```
Dayjoy-KB-FINAL/
├── README.md                          [new — explains the structure + pipeline reconciliation decisions made]
├── VERSION
├── CHANGELOG.md
│
├── 00_PROJECT_ARCHITECTURE/           [NEW — not in your original spec, but 32 real files need a home]
│   ├── system_architecture/           ← 16 files from artifacts.zip/02_System_Architecture *
│   ├── database_design/               ← 17 files from artifacts.zip/03_Database_Design *
│   ├── api_backend/                   ← 8 files from artifacts.zip/04_API_Backend_Architecture *
│   └── project_context/               ← 15 "Project_Context *" files (business context, personas, tech stack, coding standards)
│
├── 00_SOURCES/                        ← original PDFs/docx: brochure, GrowthX deck, BV price list, FSSAI license, disclaimers, policies
│
├── 01_CANONICAL/
│   ├── products/                      ← PENDING Decision 1 & 2 — canonical product master merge
│   ├── pricing/                       ← dayjoy_products_price_list_may_2026 (verified against India BV Price PDF)
│   ├── company/                       ← Dayjoy_Company_Profile.csv + dayjoy_company_overview.csv + Company_Research.md narrative, to be structured
│   ├── compensation/                  ← THIN — flagged in Missing Knowledge report, needs 04_Distributor_System.md extracted + official source
│   ├── training/                      ← EMPTY — nothing exists yet, folder created for future population
│   ├── faq/                           ← Dayjoy_All_FAQs_Combined.csv (1,884 rows) + 170 per-product files
│   ├── support/                       ← EMPTY — nothing exists yet
│   └── policies/                      ← PaymentGatewayPolicy, Social_Media_Policy, Income_Disclaimer, FSSAI license
│
├── 02_RELATIONSHIPS/
│   ├── product_relationships/         ← dayjoy_product_relationships.csv + review file (open items need closing)
│   └── knowledge_graph/               ← EMPTY — not yet built
│
├── 03_AI_DATASETS/
│   ├── intents/                       ← PENDING Decision 2
│   ├── conversations/                 ← dayjoy_ai_memory_sharegpt.* (jsonl/json/md)
│   ├── customer_journeys/             ← 07_Customer_Journey.md (from architecture doc set)
│   ├── support/                       ← EMPTY
│   └── voice/                         ← EMPTY — nothing found
│
├── 04_RAG/
│   ├── chunks/                        ← PENDING Decision 2
│   ├── metadata/                      ← dayjoy-metadata-registry-final.csv (2,242 rows) once chunks decision made
│   └── retrieval/                     ← dayjoy-search-ranking-rules.csv
│
├── 05_DATABASE/
│   ├── schema/                        ← dayjoy_database_schema.sql, dayjoy_postgresql_schema.sql (need diff — may differ)
│   ├── migrations/                    ← none found yet — flagged as gap
│   ├── seed/                          ← dayjoy_seed_data.sql, product/faq/relationship seed scripts
│   └── validation/                    ← dayjoy-data-qa-report-final.csv
│
├── 06_IMAGES/
│   └── metadata/                      ← dayjoy_image_metadata*.csv (reconcile two versions) — NOTE: zero actual image files exist, see Missing Knowledge report
│
├── 07_ANALYTICS/                      ← dayjoy_business_insights.*, best_selling/high_margin/seasonal product lists
│
├── 08_GOVERNANCE/
│   ├── source_registry/               ← NEW — file_inventory.csv + provenance chains become the source registry
│   ├── safety/                        ← product-safety-classes.csv, regulated_health_intents_review.csv
│   ├── answer_policy/                 ← canonical-answer-policy.csv
│   └── verification/                  ← dayjoy-verification-watchlist.csv, dayjoy-data-qa-report-final.csv
│
├── 09_QA/
│   ├── golden_questions/              ← EMPTY — not yet built, flagged in Missing Knowledge report
│   ├── expected_answers/              ← EMPTY
│   ├── retrieval_tests/               ← dayjoy_ai_search_test_set.csv (needs inspection — may not be sufficient)
│   └── regression/                    ← phase9-qa-test-sheet.csv
│
└── 99_ARCHIVE/                        ← everything superseded, exact-duplicate, or a re-bundled zip — nothing deleted, full manifest with reasons
```

## What moves to `99_ARCHIVE/` (safe, non-controversial — 1,696 exact-duplicate records + confirmed-superseded files from `OUTDATED_FILES.md`)

- Every `(1)`, `(2)`, `(3)` suffixed file confirmed as an exact hash match of its twin.
- Every file extracted from a nested zip that is byte-identical to a file already placed canonically (i.e., don't keep 34 copies of `dayjoy_products_master.csv`, keep one, archive the note that 33 duplicates existed and where).
- Confirmed same-pipeline-superseded files: `canonical-product-master.csv`, `canonical-product-master (2).csv`, `structured_product_master.csv`, `dayjoy-rag-chunks.csv` (2,197-row version), `metadata-registry.csv` (2,197-row version), `knowledge-gap-register.csv` (phase2), `dayjoy_master_intent_dataset_updated (2).*`.
- The 6 original top-level zips and every nested zip stay untouched at their original location (per your rule: never delete originals) — `99_ARCHIVE/` gets a manifest entry pointing back to them, not a copy.

## What does NOT move until you answer the 3 decisions above

Product master, intent datasets, RAG chunks/corpus, gap register — these stay flagged `PENDING_DECISION` rather than being silently assigned a canonical status.

---

**Once you confirm the 3 decisions (or tell me to proceed with my recommendations) and approve/amend this structure, I'll execute the physical move, generate `99_ARCHIVE/archive_manifest.csv`, and then run the full gap analysis (`KNOWLEDGE_GAP_REPORT.md` + `MISSING_DATA_TASKS.csv`) against the now-organized canonical set.**
