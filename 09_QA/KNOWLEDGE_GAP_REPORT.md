# Dayjoy Knowledge Base — Formal Gap Report

Generated: 2026-08-09, after canonical organization. Supersedes the preliminary `MISSING_KNOWLEDGE.md` scan — this version reflects what's actually in `Dayjoy-KB-FINAL/`, not just the raw files. No missing data has been generated to fill these gaps (see `MISSING_DATA_TASKS.csv` for the task list instead).

## CRITICAL — required for the AI to answer correctly without making things up

| Gap | Evidence | Why it's critical |
|---|---|---|
| **No product images anywhere.** | 0 image files across 1,803 file records. Two metadata CSVs describe images by filename that don't exist. | An assistant asked to show or confirm what a product looks like has nothing — it will either refuse or hallucinate. |
| **No structured compensation plan.** | Only 1.4KB `dayjoy_compensation_plan.csv` + 3.4KB ranks/rewards file. The real detail likely sits in the 73KB `distributor_system_narrative_UNSTRUCTURED.md`, unstructured. | Compensation questions are high-stakes (legal/financial) and currently answerable only from an unstructured narrative with no field-level source traceability — high risk of the AI paraphrasing incorrectly. |
| **Product catalog identity unresolved (Decision 1).** | `Dayjoy_Products_Catalog.csv` (86 differently-named items) never reconciled against the 170-SKU canonical master. | If these are the same products, the AI currently has two silently-inconsistent views of the same catalog. If they're different, 86 real products are invisible to the canonical master entirely. |
| **No golden-question / expected-answer evaluation set.** | 0 files matching "golden question" found; the only candidate (`dayjoy_ai_search_test_set.csv`, 1KB) is too small to be a real eval set. | Without this, there is no way to verify the AI Assist is actually answering correctly before or after launch. |

## HIGH — important for production

| Gap | Evidence |
|---|---|
| No support/operations knowledge | Zero files for refund, replacement, cancellation, shipping/delivery SLA, complaints, or escalation paths. |
| No training material | Zero files for onboarding, sales scripts, objection handling, follow-up, retention, or leadership training. |
| Company profile thin as structured data | `dayjoy_company_profile.csv` / `dayjoy_company_overview.csv` are 1-2KB; no explicit mission/vision/history/leadership/manufacturing/certifications fields — narrative exists in `company_research_narrative.md` but isn't structured. |
| Intent/RAG duplication not deduplicated | Two parallel canonical sets (1,527 vs 4,000 rows for intents; 2,242 vs 4,000 for RAG chunks) kept separate rather than merged — retrieval could surface near-duplicate or conflicting answers to the same question from each set. |
| SQL schema not verified consistent | `dayjoy_database_schema.sql` and `dayjoy_postgresql_schema.sql` were never diffed — could define the same tables differently. |
| Two unreconciled image-metadata files | `dayjoy_image_metadata_master.csv` and `dayjoy_image_metadata_alt.csv` have different row counts and were never merged — moot until actual images are sourced, but the metadata schema itself needs settling first. |

## MEDIUM — useful enhancement

| Gap | Evidence |
|---|---|
| Product-relationship review items never closed | `dayjoy_product_relationships_OPEN_REVIEW_ITEMS.csv` (62KB) contains flagged items with no resolution status. |
| No knowledge graph | `02_RELATIONSHIPS/knowledge_graph/` is empty — relationships exist as flat CSV, not a queryable graph. |
| No DB migration history | `05_DATABASE/migrations/` is empty — schema exists as a single snapshot with no change history. |
| Search/retrieval config minimal | `dayjoy_search_ranking_rules.csv` is 579 bytes — likely a stub, not a tuned ranking configuration. |

## LOW — future enhancement

| Gap | Evidence |
|---|---|
| No voice AI examples | `03_AI_DATASETS/voice/` empty — architecture docs reference a "Voice AI Architecture" (`05_VOICE_AI_ARCHITECTURE.md`) that has no corresponding dataset yet. |
| No customer support conversation examples | `03_AI_DATASETS/support/` empty — only general memory/ShareGPT examples exist, not support-specific. |
| Analytics is a snapshot, not a pipeline | `07_ANALYTICS/` has point-in-time exports (best-sellers, high-margin) with no indication of refresh cadence or source query. |

## What does NOT need more work (already solid)

- Product pricing (mrp/dp/bv) — cross-verified identical across two independent pipelines, sourced from the official BV price PDF.
- FAQ coverage — 1,884 Q&A pairs across all 170 SKUs, both combined and per-product.
- Safety/governance scaffolding — answer policy, safety classes, and regulated-content review already exist and are structurally sound, just need domain-expert sign-off rather than more data collection.
