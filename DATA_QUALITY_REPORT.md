# Data Quality Report

Metrics-first snapshot as of 2026-08-09, after the Phase 1-3 audit and fixes. For narrative detail, see `01_SOURCE_REGISTRY_AUDIT.md` through `06_REMAINING_GAPS.csv`. All numbers here were computed directly against the repository, not carried forward from memory.

## Coverage metrics

| Metric | Value |
|---|---|
| Canonical products | 170 |
| Unique product_id / sku | 170 / 170 (100% unique, 0 duplicates) |
| Products with pricing (mrp/dp/bv/pv) | 170 / 170 (100%) |
| Products with at least one ingredient/benefit/dosage field | 133 / 170 (78%) have benefits; 92 / 170 (54%) have ingredients; 98 / 170 (58%) have dosage |
| Products with warnings or contraindications | 1 / 170 each (0.6%) |
| Products with an image | 108 / 170 (63.5%) |
| Products with faq_ids populated | 170 / 170 (100%, fixed this pass) |
| Products with similar_product_ids | 170 / 170 (100%, fixed this pass) |
| Products with related_product_ids | 46 / 170 (27%, fixed this pass — limited by what the source relationships file actually contains) |
| FAQ rows | 1,884, covering all 170 products, 0 orphan SKUs |
| RAG chunks | 2,242, 0 orphan SKUs |
| Intent rows | 1,531 (deduplicated from 4,000), 0 orphan SKUs |
| Golden test questions | 169, all source-traceable |
| Source documents registered | 11 / 11 (100%, new this pass) |

## Integrity checks (all computed, none assumed)

| Check | Result |
|---|---|
| Duplicate product_ids | 0 |
| Duplicate SKUs | 0 |
| Duplicate product names (exact) | 0 |
| Near-duplicate product names (fuzzy, manually reviewed) | 34 pairs found, all confirmed legitimate distinct SKUs, 0 true duplicates |
| mrp < dp violations | 0 / 170 |
| bv > dp violations | 0 / 170 |
| pv != bv | 0 / 170 |
| Pricing file vs. product master mrp/dp mismatches | 0 / 170 |
| Pricing file vs. product master bv mismatches | 0 / 151 comparable rows |
| Image metadata broken paths | 0 / 126 (was 90/120 = 75% before this pass) |
| Placeholder/invented content sweep (n/a, tbd, lorem ipsum, etc.) | 0 matches across 8 content columns |
| Rows with factual content but no source citation | 0 / 170 |

## Verification tier distribution (per `08_GOVERNANCE/verification/CLAIM_VERIFICATION_STANDARD.md`)

| Tier | What's in it |
|---|---|
| VERIFIED | Compensation rank/reward table (17/17 rows, OCR cross-checked against source PDF, 100% match). Pricing (mrp/dp/bv/pv, cross-checked zero-mismatch between two independent representations). |
| UNVERIFIED | Product benefits/dosage/ingredients/usage (sourced from brochure text, not independently medically verified — `content_risk_level=high` on all 170 rows, by design). 3 compensation figures explicitly `CONFLICT_UNRESOLVED`. |
| INFERRED | All 6 files in `07_ANALYTICS/metrics/` (best-selling, high-margin, popular categories, seasonal, income opportunities, business insights) — proxy/derived, not real sales or earnings data, labeled as such. |

## Known governance-signal weakness (not fixed this pass — flagged, needs redesign)

`verification_status`, `approval_status`, `content_risk_level`, `pricing_risk_level`, and `missing_content_fields_count` are uniform across all 170 product rows — they don't currently discriminate a well-verified product from a poorly-verified one. `confidence` is a compound string, not a numeric score. This is a real limitation for any system that wants to use these columns as a per-row trust signal. Fixing it requires redesigning what these columns measure, not backfilling missing values — logged as gap G011/G012 in `06_REMAINING_GAPS.csv`.

## What this report does not cover

Conversational quality, multi-turn handling, safety-refusal behavior, and the 3 unresolved compensation conflicts are not data-quality-metric problems — they need a human decision or new source material, not a script. See `06_REMAINING_GAPS.csv` for the complete list with `requires_human_decision` flagged per item.
