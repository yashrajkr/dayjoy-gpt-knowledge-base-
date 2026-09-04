# Changelog

## 3.1.0-maximum-fill — 2026-08-10

Targeted gap-closure pass in direct response to the prior audit's named blockers. Did not redo any completed audit (01-06 series untouched) — every agent this pass was scoped strictly to fixing/filling, not re-auditing. Four parallel work areas, each grounded in real source re-mining or mechanical cleanup. Full detail in the updated `DATA_QUALITY_SCORING.md` and `PRODUCTION_READINESS.md`.

### Fixed / Filled — Product Master & Pricing
- Discovered the product brochure PDF (`Dayjoy Product Brochure - English July2026_11zon.pdf`) was scanned/image-based and had never been fully OCR'd in any prior pass. Rendered and OCR'd all 78 pages (Tesseract), recovering 8 pages that silently failed the first OCR attempt and a 400dpi re-scan of 1 garbled line. Filled 16 real content cells: dosage +14, contraindications +1 (JuniorJoy), ingredients +1. See `01_CANONICAL/products/T002_BROCHURE_REEXTRACTION_SUMMARY.md` — honestly documents that 168/170 products still lack warnings/certifications because the source brochure is marketing collateral, not a regulatory label; this is now a confirmed ceiling, not an unknown.
- All 3 catalog86 pricing conflicts (Deep Cleansing Face Wash, Prosperous+, Aqua Energiser) re-investigated and found to be wrong-SKU cross-check errors, not real disagreements — corrected SKUs applied, status changed to `RESOLVED_NOT_A_CONFLICT_WRONG_SKU_MATCH`.
- "Neem & Aloevera Herbal Soap" unmatched catalog item re-examined; candidate match elevated to ~0.6 confidence with new corroborating price/pack evidence but deliberately not auto-merged due to a conflicting ingredient name — correctly left for human decision.

### Fixed / Filled — Company Knowledge, Support
- Deep-mined previously under-used source PDFs; added real FSSAI License No. 12224999000129 (valid 12-03-2025 to 11-03-2030), 4 manufacturer addresses, and PAN/IEC AAGCD8452J to `dayjoy_company_knowledge.csv`. Rows grew 65 -> 69 (43 VERIFIED / 26 UNVERIFIED).
- Shipping/Refund Policy gap actively re-searched (not just re-reported): confirmed `Dayjoy_Online_Shopping.pdf` is an order-placement UI walkthrough with zero policy content, and that two docx-cited shipping/return figures trace to third-party sites, not Dayjoy. Confirmed genuinely absent; new `SLA-07` row documents the re-check.

### Fixed — Compensation
- The "second compensation document" risk (`distributor_system_narrative_UNSTRUCTURED.md`) traced to its true origin: Mission 4 output of a 12-mission AI web-research pipeline, never an official Dayjoy document. Downgraded from a real conflicting source to confirmed non-authoritative. `compensation_gap_report.csv` and `01_CANONICAL/compensation/README.md` updated.
- The 3 remaining CONFLICT_UNRESOLVED compensation figures re-investigated a second time against the GrowthX OCR text with a new `additional_context_found_on_reinvestigation` column — no disambiguating context exists in the source. Correctly left unresolved; this needs a Dayjoy human decision, not more processing.

### Fixed — RAG
- Deduplicated `dayjoy_rag_chunks_CANONICAL.csv` from 2,242 to 882 rows (77 duplicate-text groups collapsed, 1,360 redundant "information not available" rows dropped, most metadata-complete representative kept per group). Verified 0 content lost, 0 orphan SKU references post-dedup. Pre-dedup version archived, not deleted. Metadata registries updated to match.

### Fixed — Images
- Full re-unzip and cross-check of the source image archive recovered 1 additional genuine match: `Joy_1.jpg` -> `DJ-AGR-0135` (HAPPYGROW JoyProtect 500ml), ~0.98 confidence, cross-verified against the 86-item catalog. Image coverage 108 -> 109/170 (64.1%). The remaining 61 photo-less SKUs and 7 previously-declined images re-confirmed genuinely unmatched (6 are distributor bundle posters with no SKU, 1 is an unrelated magnetic bracelet).

### Updated — Scoring, Readiness, Reports
- `DATA_QUALITY_SCORING.md`: overall KB score ~85 -> ~87/100, with a full before/after table and an explicit explanation of which 5 items cannot honestly reach 100 and why (confirmed source-material ceilings, not unfinished work).
- `PRODUCTION_READINESS.md`: blocker list updated — 1 blocker fully resolved (pricing conflicts), 1 materially downgraded (second compensation document), 1 partially improved with the remainder confirmed as a real ceiling (images/content sparsity), 2 remain genuinely open (3 compensation conflicts, Shipping/Refund Policy) after active re-investigation confirmed they cannot currently be closed without new input from Dayjoy.
- `06_REMAINING_GAPS.csv`: G013, G014, G026, G027 updated with re-investigation findings; G026B, G030, G031, G032 added for this pass's new fixes.

## 3.0.0-integration-ready — 2026-08-09

Full master-KB completion pass across 26 requested phases, built directly on top of v2.1.0-audited without regenerating any existing canonical dataset. Six parallel work areas, each producing real, sourced content (or an honestly-documented gap) — no Dayjoy fact was invented anywhere. Full detail: `CROSS_DATA_VALIDATION_REPORT.md`, `DATA_QUALITY_SCORING.md`, `PRODUCTION_READINESS.md`.

### Added — Company, Safety, Support
- `01_CANONICAL/company/dayjoy_company_knowledge.csv` (65 rows, real facts + honest NULL/UNVERIFIED gaps).
- `08_GOVERNANCE/safety/`: `medical_claim_policy.md`, `product_claim_policy.md`, `dosage_policy.md`, `diagnosis_policy.md`, `income_claim_policy.md`, `compensation_policy.md`, `privacy_policy.md`, `escalation_policy.md`.
- `01_CANONICAL/support/`: `support_intents.csv`, `support_policies.csv`, `support_decision_tree.md`, `support_escalation_rules.csv`, `support_sla.csv`, `support_contacts.csv`, `support_required_information.csv`, `support_allowed_actions.csv`, `support_prohibited_promises.csv` (replaces placeholder README).

### Added — Compensation, Training
- `01_CANONICAL/compensation/compensation_rules.csv` (81 rules: 48 VERIFIED / 30 UNVERIFIED / 3 CONFLICT), `compensation_examples.csv` (4 literal OCR worked examples), `compensation_gap_report.csv` (11 gaps, including newly-discovered gap G-002 — a second, uncorroborated compensation document).
- `01_CANONICAL/training/training_curriculum.csv` (30 lessons: 22 DAYJOY_SOURCED, 8 GENERIC_METHODOLOGY, clearly labeled) — replaces placeholder README.

### Added — FAQ, Relationships, Knowledge Graph, Memory
- `01_CANONICAL/faq/dayjoy_faq_canonical_v2.csv` (1,897 rows), `faq_gap_report.csv` (12 documented category gaps — shipping/returns/training/account/technical confirmed empty, not padded).
- `02_RELATIONSHIPS/product_relationships/product_relationship_edges.csv` (4,119 edges, 0 orphans).
- `02_RELATIONSHIPS/knowledge_graph/kg_nodes.csv` (2,434 nodes), `kg_edges.csv` (3,977 edges, 0 orphans) — replaces placeholder README.
- New top-level `10_MEMORY/`: 7 memory schema docs + isolation policy — schema-only, no real user data exists yet.

### Added — AI Intents, RAG, Retrieval, Conversations, Web
- `03_AI_DATASETS/intents/dayjoy_intents_STRUCTURED.csv` (1,531 rows + entities/required_tool/answer_source), `dayjoy_intents_SUPPLEMENTARY_categories.csv` (95 new synthetic rows, clearly labeled).
- `04_RAG/metadata/dayjoy_metadata_registry_ENRICHED.csv` (2,242 rows, +9 fields); found and documented 1,360 duplicate/near-duplicate chunk rows (not yet deduplicated — flagged as a follow-up).
- `04_RAG/retrieval_rules/RETRIEVAL_STRATEGY.md`.
- `03_AI_DATASETS/conversations/conversation_examples_LABELED.csv` (36 rows), `03_AI_DATASETS/voice/voice_training_examples.csv` (17 rows) — both explicitly marked synthetic training/eval data.
- New top-level `14_WEB/`: web-search-vs-canonical-knowledge separation policy.

### Added — SQL/Database, Business Analytics, Images
- `05_SQL/schema/dayjoy_full_production_schema.sql` — 27 new tables (profiles/roles/business-data/memory/conversations/training/knowledge), all business-data tables schema-only with no seeded rows.
- `05_SQL/schema/relationships.sql`, `indexes.sql`, `rls_policies.sql` (DRAFT, roles reconciled against actual `role_scope` values found in RAG chunks), `05_SQL/migrations/001_initial_extended_schema.sql`.
- `07_ANALYTICS/schemas/business_analytics_entity_schemas.md` — schemas only, no fabricated figures.
- `06_IMAGES/metadata/dayjoy_image_metadata_FULL_SCHEMA.csv` (126 rows, all 10 requested columns).

### Added — Evaluation, Golden Dataset
- `09_QA/evaluation/evaluation_dataset.csv` — 1,060 rows across 8 categories, every factual expected_answer traced to real canonical data; some category targets honestly fell short (e.g. policy=42 of a 100 target, because only ~29 real facts exist in the 3 policy PDFs).
- `09_QA/test_questions/dayjoy_golden_questions_v2_ADDITIONS.csv` (51 new rows, verified zero overlap with the existing 169 — combined golden set now 220 rows).
- `09_QA/GOLDEN_SET_USAGE.md`.

### Added — Cross-cutting reports
- `CROSS_DATA_VALIDATION_REPORT.md`, `DATA_QUALITY_SCORING.md`, `PRODUCTION_READINESS.md`, `RELEASE_NOTES.md` — new, at repo root.

### Fixed
- 5 malformed CSVs from this pass (unquoted commas / stray header-note rows) caught in a full 267-file sweep and repaired in place: `support_intents.csv`, `support_escalation_rules.csv`, `support_prohibited_promises.csv`, `support_required_information.csv`, `support_allowed_actions.csv`. All 267 live CSVs now parse cleanly.

### New findings surfaced (not previously documented, not silently absorbed)
- A "Shipping/Refund Policy" document is cited throughout the intents/FAQ data as a source but does not exist anywhere in the repository.
- A second, uncorroborated compensation document (`distributor_system_narrative_UNSTRUCTURED.md`) describes materially different bonus/reward structures than the OCR-verified GrowthX deck — a bigger conflict than the 3 previously-known ones, now tracked as gap G-002.
- 61% of RAG chunks (1,360 of 2,242) are duplicate/near-duplicate placeholder text — not yet cleaned, documented as a follow-up.

### Not changed
- Every canonical fact from v2.1.0-audited (pricing, product identity, compensation ranks, FAQ v1) remains byte-identical except where explicitly listed above as fixed. Nothing was deleted.

---

## 2.1.0-audited — 2026-08-09

Strict production-readiness audit of Phase 1 (Source Registry), Phase 2 (Product Master), Phase 3 (Pricing Master), plus cross-data validation, run against the existing v2.0.0-governed repository. No dataset was regenerated from scratch. Every fix below is a structural fix (populating an empty field from already-verified data elsewhere in the repo, correcting a citation typo, or labeling/archiving a known-bad file) — no Dayjoy fact was invented. Full detail: `01_SOURCE_REGISTRY_AUDIT.md` through `06_REMAINING_GAPS.csv` at the repo root.

### Audit verdicts
- Phase 1 (Source Registry): READY WITH FIXES → fixed this pass.
- Phase 2 (Product Master): READY WITH FIXES → partially fixed this pass (identity/pricing/relationships fixed; content gaps and rubber-stamp governance columns remain open, need new source material or a redesign, not a data fix).
- Phase 3 (Pricing Master): READY WITH FIXES → fixed this pass.

### Added
- `08_GOVERNANCE/source_registry/source_registry.csv` — new, 11 rows (one per genuine physical source document), with source_id/filename/source_type/checksum/authority/status/notes populated and document_date populated where evidenced by the filename. `source_url`/`date_obtained`/`version`/`supersedes` correctly left empty where no evidence exists anywhere in the repo — not invented.
- `08_GOVERNANCE/source_registry/README.md` — explains the registry vs. `file_inventory.csv` (raw 1,803-row extraction audit) distinction, and states `source_id`/`checksum` as the only safe join keys (a filename collision was found and documented in the audit).
- `08_GOVERNANCE/source_registry/PRICING_AUTHORITY_STATEMENT.md` — names `dayjoy_price_list_may2026.csv` as the authoritative current-pricing source, citing the zero-mismatch verification against the product master.
- `01_CANONICAL/pricing/README.md` — labels `dayjoy_price_list_extracted_from_pdf.csv` as a corrupted, superseded draft extraction (row-merging errors verified) that must not be used.
- `01_CANONICAL/products/T001_CATALOG_MERGE_SUMMARY.md` — reconstructed from already-verified audit CSVs; was cited as evidence in multiple places but had never actually been written.
- `01_SOURCE_REGISTRY_AUDIT.md`, `02_PRODUCT_MASTER_AUDIT.md`, `03_PRICING_MASTER_AUDIT.md`, `04_CROSS_DATA_VALIDATION.md`, `05_PRODUCTION_READINESS_REPORT.md`, `06_REMAINING_GAPS.csv` — new, at repo root, the full audit trail for this pass.
- `FILE_MANIFEST.csv`, `RELEASE_MANIFEST.csv`, `DATA_QUALITY_REPORT.md` — new, at repo root.

### Fixed (structural, all traceable to already-existing verified data)
- `01_CANONICAL/pricing/dayjoy_price_list_may2026.csv` (+ `.json`, `_supabase.sql`): backfilled `sku` (170/170) and added `product_id` (170/170) via a verified zero-mismatch name-join to the product master; backfilled `pv` (170/170) and the 19 previously-missing `bv` values, all copied from the product master, not invented.
- `01_CANONICAL/products/dayjoy_product_master_canonical.csv`: backfilled `faq_ids` (170/170, joined from the FAQ file on sku), `similar_product_ids` (170/170) and `related_product_ids` (46/170, from `02_RELATIONSHIPS/product_relationships/`), `image_ids` (108/170 — the 62 SKUs with no photo correctly left empty, not faked); corrected the `content_source_document` citation typo (`_11zon_2.pdf` → `_11zon.pdf`) in 130/170 rows.
- `06_IMAGES/metadata/dayjoy_image_metadata_CANONICAL.csv`: rebuilt from the 126 real files actually on disk — was 90/120 (75%) broken paths, now 0/126 broken.
- `01_CANONICAL/products/catalog86_pricing_crosscheck_conflicts.csv`: added a `status` column (`CONFLICT_UNRESOLVED`) to match the schema already used by `dayjoy_compensation_conflicts.csv`, so both conflict-tracking files are filterable the same way.

### Archived (originals preserved, not deleted)
- Pre-fix copies of `dayjoy_price_list_may2026.csv/.json/_supabase.sql`, `dayjoy_price_list_extracted_from_pdf.csv`, `dayjoy_product_master_canonical.csv`, `dayjoy_image_metadata_CANONICAL.csv`, and `catalog86_pricing_crosscheck_conflicts.csv` — all saved to `99_ARCHIVE/superseded/` with a `_PRE_FIX_2026-08-09` suffix before any in-place edit.

### Not changed — remain open by design (see `06_REMAINING_GAPS.csv` for the full list with reasons)
- `description`, `unit`, `sub_category` in the product master remain empty — filling them would require new content, not just linking existing data.
- `verification_status`/`confidence`/`content_risk_level` remain uniform across all 170 rows — a known governance-signal design issue, not something a data fix can resolve.
- 3 compensation conflicts, 1 unmatched catalog item, 62 SKUs without a photo, no price-history mechanism, no website snapshot — all carried over, all need either a human decision or new source material.

---

## 2.0.0-governed — 2026-08-09

New repository: `Dayjoy-Knowledge-Base`, restructured from `Dayjoy-KB-FINAL` (v1.1.0-verified) into the governed folder layout the user specified. This is a reorganization plus a governance addition, not a re-audit and not a data regeneration — no canonical dataset content was recomputed in this pass.

### Structural changes
- `00_SOURCES/` → `00_SOURCE_DOCUMENTS/`, split into `brochures/`, `price_lists/`, `policies/`, `compensation/`, `company/`, `website_snapshots/` (new).
- `05_DATABASE/` → `05_SQL/` (contents unchanged).
- `04_RAG/retrieval/` → `04_RAG/retrieval_rules/`; added `04_RAG/embeddings_manifest/` (empty, gated — see its README).
- `07_ANALYTICS/` (flat) → split into `demo/`, `schemas/`, `metrics/` (existing files moved into `metrics/`).
- `09_QA/golden_questions/` → `09_QA/test_questions/` (contents unchanged, README updated).
- Added `02_RELATIONSHIPS/category_graph/`, `03_AI_DATASETS/faq/`, `08_GOVERNANCE/audit/`, `99_ARCHIVE/duplicates/`, `99_ARCHIVE/outdated/` — all documented as either populated-by-reference or genuinely-empty gaps, not silently created and left blank.
- `01_CANONICAL/`, `02_RELATIONSHIPS/product_relationships/`, `02_RELATIONSHIPS/knowledge_graph/`, `03_AI_DATASETS/{intents,conversations,customer_journeys,support,voice}`, `04_RAG/{chunks,metadata}`, `06_IMAGES/`, `08_GOVERNANCE/{source_registry,verification,safety,answer_policy}`, `09_QA/{expected_answers,retrieval_tests,regression}`, `99_ARCHIVE/superseded` carried over as direct copies.
- `00_PROJECT_ARCHITECTURE/` carried over unchanged at root (not part of the numbered tree, same rationale as in `Dayjoy-KB-FINAL`).
- `08_GOVERNANCE/audit/` newly populated with the original repository-wide audit reports (`FILE_INVENTORY.md`, `DUPLICATE_REPORT.md`, `OUTDATED_FILES.md`, `MISSING_KNOWLEDGE.md`, `PROPOSED_STRUCTURE.md`, full raw inventory CSV), previously sitting outside any KB folder.

### Fixed
- **Image de-duplication bug.** The prior pass in `Dayjoy-KB-FINAL` excluded every file matching the pattern `<name>_<N>.<ext>` as an assumed accidental duplicate. That pattern also matches legitimate second/third product photos, which happen to use the same naming convention. Re-checked by SHA-256 content hash instead of filename: 92 files were true byte-identical duplicates (correctly excluded) and 16 were genuinely different photos (wrongly excluded before, restored now). Net result: 126 image files across 108 SKUs, versus the previously reported 120.

### Added — governance layer (new, not present in Dayjoy-KB-FINAL)
- `08_GOVERNANCE/verification/CLAIM_VERIFICATION_STANDARD.md` — defines VERIFIED / UNVERIFIED / INFERRED, maps existing datasets to each tier, flags a real inconsistency in the product master (`verification_status`="approved" vs `content_risk_level`="high" on the same rows) and states which one governs.
- `08_GOVERNANCE/answer_policy/ABSTAIN_AND_LABELING_POLICY.md` — mandatory label-or-abstain rules for health benefits, dosage, compensation figures, "best-selling" claims, and business/income claims, with exact disclaimer text.
- `00_SOURCE_DOCUMENTS/website_snapshots/WEBSITE_SNAPSHOT_POLICY.md` + `website_snapshot_log.csv` — treats the Dayjoy public website as a live, versioned source requiring the same registration/verification pipeline as any PDF, not as a trusted feed and not as sole source of truth. No website content was captured or invented in this pass — the folder is an empty, ready-to-use process, not a placeholder pretending to be data.
- `07_ANALYTICS/metrics/README.md` — explicit per-file verification-tier table; confirms every analytics file is INFERRED (proxy/derived), never real sales or earnings data.
- `04_RAG/embeddings_manifest/README.md` — states explicitly why embeddings have not been generated and what must resolve first (the 3 compensation conflicts, the 1 unmatched catalog item, any future website-sourced facts).
- `LICENSE-AND-USAGE.md` — new, defines internal-use terms and the non-negotiable rule that health/dosage/compensation/income content must always carry its verification tier when reused downstream.

### Not changed
- All canonical facts (pricing, compensation ranks, product master, FAQ, intents, RAG chunks) are byte-identical to `Dayjoy-KB-FINAL` v1.1.0-verified except for the image-folder fix above. The 3 compensation conflicts and the 1 unmatched catalog item remain open — see `PRODUCTION_READINESS_REPORT.md`.

---

## Prior history (inherited from Dayjoy-KB-FINAL)

### 1.1.0-verified — 2026-08-09
Executed T001-T004, T013-T015 against new user-supplied sources (product images ZIP, GrowthX compensation deck) and user confirmation that the 86-item catalog is the same product line. See prior entries preserved in `08_GOVERNANCE/audit/` and `99_ARCHIVE/`.

### 1.0.0-organized — 2026-08-09
Initial organization pass of the raw 216-file source folder into a canonical structure. No new facts were invented; no original files were deleted or modified.
