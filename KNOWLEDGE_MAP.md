# Dayjoy Knowledge Base — Knowledge Map

Generated: 2026-08-09. Last updated: 2026-08-09 (26-phase master KB completion pass, v3.0.0-integration-ready). One-page answer to "what exists, where does it live, and is it ready."

| Domain | Canonical location | Production-ready? | Notes |
|---|---|---|---|
| Source registry | `08_GOVERNANCE/source_registry/source_registry.csv` | **Yes, for the 11 real documents** | Newly built this pass — filename, source_type, authority tier, checksum, status, notes populated; source_url/date_obtained/version/supersedes correctly left empty (not recoverable, not invented). |
| Products | `01_CANONICAL/products/dayjoy_product_master_canonical.csv` | **Yes for identity/pricing, partial for content/relationships** | product_id/sku 170/170 unique. mrp/dp/bv/pv internally consistent, zero violations. 86-vs-170 catalog conflict resolved (85/86 matched). faq_ids 170/170 and similar_product_ids 170/170 now populated (this pass); image_ids 108/170 (62 SKUs have no photo — needs new source material); ingredients/benefits/dosage remain genuinely sparse (real content gaps, not a data-loss artifact); verification_status/confidence columns are uniform rubber stamps, not differentiated signals — known issue, not fixed this pass (needs redesign). |
| Pricing | `01_CANONICAL/pricing/dayjoy_price_list_may2026.csv` | **Yes** | sku/product_id backfilled 170/170 this pass (verified zero-mismatch join to product master). mrp/dp/bv/pv agree with the product master with zero conflicts. `dayjoy_price_list_extracted_from_pdf.csv` confirmed corrupted/superseded, now labeled as such in `01_CANONICAL/pricing/README.md`, archived copy kept. No price-history mechanism exists yet (single current price only) — open gap, needs schema design. |
| Company | `01_CANONICAL/company/dayjoy_company_knowledge.csv` | **Partially** | 65 facts consolidated this pass; real gaps (detailed history, full certifications list) marked NULL/UNVERIFIED, not guessed. |
| Compensation | `01_CANONICAL/compensation/` | **Mostly, with a new flag** | 81 structured rules (48 VERIFIED/30 UNVERIFIED/3 CONFLICT). **New finding**: a second, uncorroborated compensation document disagrees with the verified GrowthX PDF on ~12 income-stream details — needs Dayjoy team confirmation before either can be trusted. |
| Training | `01_CANONICAL/training/training_curriculum.csv` | **Partially** | 30 lessons this pass (22 DAYJOY_SOURCED, 8 GENERIC_METHODOLOGY clearly flagged as draft). |
| FAQ | `01_CANONICAL/faq/` | **Yes** | 1,884 Q&A pairs, full 170-SKU coverage, zero orphan SKUs against the product master (verified in cross-data validation). Note: FAQ's own `product_id` column is a meaningless row number — use `sku` or `product_code` to join, not `product_id`. |
| Support | `01_CANONICAL/support/` | **Partially** | 9 support files built this pass (intents, policies, decision tree, escalation, SLA [empty by honesty], contacts, prohibited promises). Surfaced a real gap: the "Shipping/Refund Policy" cited throughout doesn't exist in the repo. |
| Policies | `01_CANONICAL/policies/` | **Yes** | FSSAI license, payment gateway, social media, income disclaimer all present. |
| Product relationships | `02_RELATIONSHIPS/product_relationships/` | **Yes, and now wired in** | Used this pass to backfill product master's similar_product_ids (170/170) and related_product_ids (46/170). |
| Category graph | `02_RELATIONSHIPS/category_graph/` | **No — empty, by design** | Not yet built — see its README. |
| Knowledge graph | `02_RELATIONSHIPS/knowledge_graph/` | **No — empty** | Not yet built. |
| Intents | `03_AI_DATASETS/intents/` | **Yes** | Deduplicated to 1,531 canonical rows; zero orphan SKUs against the product master. |
| Conversations | `03_AI_DATASETS/conversations/` | **Partially** | General memory/ShareGPT examples exist; no support-specific examples. |
| RAG chunks | `04_RAG/chunks/` | **Yes** | 2,242 canonical chunks, zero orphan SKUs against the product master. |
| RAG metadata | `04_RAG/metadata/` | **Yes** | Canonical registry present, 2,242 chunks tracked. |
| RAG embeddings | `04_RAG/embeddings_manifest/` | **No — empty, by design** | Deliberately not generated until the compensation conflicts and any other gate items resolve — see that folder's README. |
| Retrieval rules | `04_RAG/retrieval_rules/` | **Yes** | Ranking rules and search config present. |
| SQL schema | `05_SQL/schema/` | **Yes** | Two schema files diffed and reconciled; not in conflict. |
| SQL seed data | `05_SQL/seed/` | **Yes** | Present for products, FAQs, relationships. |
| SQL migrations | `05_SQL/migrations/` | **No — empty** | No version history. |
| Images | `06_IMAGES/` | **Partially** | 126 real image files covering 108/170 SKUs. Metadata file rebuilt this pass — 0/126 broken paths now (was 90/120 broken before this pass). 62 SKUs still have no photo at all — needs new source material from Dayjoy. |
| Analytics | `07_ANALYTICS/metrics/` | **Yes, as a labeled proxy** | All files explicitly marked INFERRED tier (mention-frequency/derived, not real sales or earnings data) — see that folder's README. |
| Governance / safety | `08_GOVERNANCE/` | **Yes, structurally** | Answer policy, abstain policy, safety classes, verification standard, source registry all present. |
| QA / golden questions | `09_QA/test_questions/` | **Yes** | 169 sourced Q&A pairs, factual/retrieval accuracy only. |
| QA / regression tests | `09_QA/regression/` | **Partially** | `phase9_qa_test_sheet.csv` exists; conversational/safety eval still needed. |

## Canonical vs. archived, at a glance

- **440** files had genuinely unique content out of 1,803 total file records found across the entire (fully unpacked) source.
- **~315** of those 440 (plus new files created during merging/documentation) are now placed canonically in this tree.
- **136** unique-content files were superseded/not selected — documented + physically archived (where small enough) in `99_ARCHIVE/`.
- **1,696** were exact byte-for-byte duplicates of something else — documented by reference in `99_ARCHIVE/archive_manifest.csv`, not re-copied.
- **0** files were deleted. Every original remains at its original location outside this folder.

## Still open

Decision 1 (product catalog identity, T001) and Decision 2's intent/RAG follow-up (T013/T014) are the two structural issues most worth resolving before heavy production use — everything else in `MISSING_DATA_TASKS.csv` is additive content work that doesn't block using what already exists.
