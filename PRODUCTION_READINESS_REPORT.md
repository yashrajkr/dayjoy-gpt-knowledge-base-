# Dayjoy Knowledge Base — Production Readiness Report

Generated: 2026-08-09. Carried forward from `Dayjoy-KB-FINAL` (v1.1.0-verified) after T001-T004, T013-T015, then updated for the move into `Dayjoy-Knowledge-Base` (governed structure). No dataset was regenerated during either pass — every change is a targeted merge, verification, reconciliation, or governance addition, with full source traceability. Nothing was deleted; superseded files remain in `99_ARCHIVE/`.

## COMPLETED

| Item | What changed | Evidence |
|---|---|---|
| **T001 — Catalog identity** | Confirmed by you: the 86-item catalog is the same 170-SKU line. Fuzzy-matched and merged 85 of 86 items into `dayjoy_product_master_canonical.csv`, backfilling only NULL fields (ingredients 50→93/170, benefits 131→134/170, dosage 47→98/170). Two automated false-positive matches were caught by manual review and corrected before saving. | `01_CANONICAL/products/T001_CATALOG_MERGE_SUMMARY.md`, `08_GOVERNANCE/source_registry/catalog86_merge_audit.csv` |
| **T003 — Compensation plan** | OCR'd the 58-page GrowthX deck (no text layer — every slide is a flattened image). Cross-verified all 17 rank/reward rows against the source: **100% exact match**, marked VERIFIED with page citations. Added genuinely new sourced data (cashback tiers, loyalty programs, eligibility BV table, 10 T&C rules). | `01_CANONICAL/compensation/dayjoy_plan_ranks_rewards_VERIFIED.csv`, `dayjoy_compensation_plan_ADDITIONAL_VERIFIED.csv`, `dayjoy_compensation_terms_and_conditions.csv` |
| **T013 — Intent pipeline** | Pipeline B (4,000 rows) was pipeline A's 1,527 questions padded with duplicates, not a richer dataset. Deduplicated to 1,531 unique rows, merged in pipeline A's governance columns. | `03_AI_DATASETS/intents/dayjoy_intents_CANONICAL.csv` |
| **T014 — RAG pipeline** | Pipeline A (2,242 chunks) verified as the real sourced RAG corpus (1,884 FAQ chunks match the canonical FAQ file row-for-row). Pipeline B is 100% redundant with the intent dataset. Adopted pipeline A as sole canonical RAG corpus. | `04_RAG/chunks/dayjoy_rag_chunks_CANONICAL.csv` |
| **T015 — SQL schema** | Diffed both schema files table-by-table — never in conflict, one real design overlap resolved by recommendation. | `05_SQL/schema/T015_SCHEMA_RECONCILIATION.md` |
| **Image de-dup bug fix** | The prior de-duplication pass wrongly excluded 16 legitimate multi-angle product photos along with 92 real accidental duplicates, because it matched on filename pattern (`_N.ext`) instead of content. Re-done with SHA-256 comparison: 126 real image files kept (covering 108 SKUs), 92 true duplicates correctly excluded, 16 wrongly-excluded real photos restored. | `06_IMAGES/products/`, CHANGELOG |
| **Governance layer** | Added a formal VERIFIED/UNVERIFIED/INFERRED verification standard, an abstain-and-labeling policy for health, dosage, compensation, "best-selling," and income claims, and a website-as-versioned-source policy. | `08_GOVERNANCE/verification/CLAIM_VERIFICATION_STANDARD.md`, `08_GOVERNANCE/answer_policy/ABSTAIN_AND_LABELING_POLICY.md`, `00_SOURCE_DOCUMENTS/website_snapshots/WEBSITE_SNAPSHOT_POLICY.md` |

## PARTIALLY COMPLETED

| Item | Status | Remaining gap |
|---|---|---|
| **T002 — Product images** | 126 image files now placed, covering 108 of 170 SKUs (several with 2-3 angles). 8 uploaded images declined — no confident canonical match. | 62 products still have zero image — no source photo was ever supplied for them. |
| **T004 — Golden evaluation set** | 169 question/answer pairs built, every one traceable to a canonical source record. | Covers factual/retrieval accuracy only — not conversational quality, multi-turn handling, or safety-refusal behavior. |

## BLOCKED — needs your decision, not more processing

| Item | Why it's blocked |
|---|---|
| 1 of 86 catalog items ("Neem & Aloevera Herbal Soap") | No confident canonical match exists. May be a genuinely missing SKU. |
| 62 products without images | Needs more source photos from Dayjoy marketing. |
| 8 uploaded images without a match | 6 are named after marketing combo kits that don't correspond to any of the 6 canonical `COMBO PACKAGES` SKUs. 1 shows a magnetic bracelet with no matching SKU. 1 has too generic a filename. |
| Website snapshot | Not yet captured — `00_SOURCE_DOCUMENTS/website_snapshots/` is empty by design. Nothing invented to fill it. |

## CONFLICTING — flagged, not silently resolved

| Conflict | Old value (no source) | Authoritative PDF value | Status |
|---|---|---|---|
| Retail Profit rate | "Up to 30% / 50%" | "UP TO 100%" (headline), worked example shows 20% on one case | **Needs your call** |
| Mentorship Bonus rate | "100% of binary" | "50% of Direct Introduced Distributor's Business Matching Incentive" (worked examples) | Recommend adopting PDF value |
| Business Matching Incentive structure | Flat Rs 500/pair, daily capping | Tiered (Rs 250-1000 by BV level), weekly closing/payout | Recommend adopting PDF value |
| 3 pricing mismatches from the 86-item catalog | Deep Cleansing Face Wash, Prosperous+, Aqua Energiser | Canonical (verified) pricing kept as-is | Logged, not auto-resolved |

Full detail: `01_CANONICAL/compensation/dayjoy_compensation_conflicts.csv`

## REMAINING — unchanged from the original gap report

Training material, support/SLA content, and full company profile structuring (history, certifications, manufacturing locations) remain open. `category_graph/` (relationships) and an AI-training-shaped FAQ variant are also open — see their folder READMEs.

## Gate check — do not proceed to application integration until:

- [x] Canonical catalog — resolved (T001)
- [ ] Compensation data — **verified but has 3 unresolved conflicts**, needs your decision
- [x] Golden evaluation set — built for factual accuracy; conversational/safety eval still needed before full launch confidence
- [x] RAG pipeline — resolved (T014)
- [x] Intent pipeline — resolved (T013)
- [x] SQL schema — resolved (T015)
- [ ] Embeddings — **not generated, by design** — gated on the compensation conflicts above and on any future website-sourced facts being registered (see `04_RAG/embeddings_manifest/README.md`)

**You are one decision away from clearing the data gate**: confirm which value to use for the 3 compensation conflicts. Embeddings generation is a separate, mechanical step once that's clear — it should not happen before it, so retrieval never has to be rebuilt against a value that later changes.
