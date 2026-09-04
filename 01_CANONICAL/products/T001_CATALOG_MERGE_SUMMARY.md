# T001 — 86-Item Catalog Merge Summary

**Status:** Reconstructed 2026-08-09. This file was cited as evidence for the 86-vs-170 catalog merge in `PRODUCTION_READINESS_REPORT.md` and `09_QA/MISSING_DATA_TASKS.csv` (task T001) but did not exist in the repository. It has been reconstructed here directly from the three CSVs that already contain the verified merge data (no new research, no invented facts — every figure below is read from the cited files).

## Sources

- `08_GOVERNANCE/source_registry/catalog86_merge_audit.csv` (91 data rows)
- `01_CANONICAL/products/dayjoy_products_catalog_86items_UNMATCHED.csv` (4 candidate rows)
- `01_CANONICAL/products/catalog86_pricing_crosscheck_conflicts.csv` (3 rows)

## Outcome: 85 of 86 catalog items matched

`catalog86_merge_audit.csv` contains 91 rows covering **85 unique `catalog86_name` values**, each with a `matched_sku` (0 nulls). The row count exceeds the unique-name count because 6 catalog items are bundles that map to two canonical SKUs each (1-to-2 matches):

- Premium Sanitary Pads
- Orthofix Tablet & Oil
- Go Piles Tablet & Syrup
- Eye Elixir Drops & Eye Health++ Capsule
- Adiliv Tablet / LivEase Syrup
- Adicardial Tablet & Syrup

85 unique names + 6 extra bundle rows = 91 rows.

Three of the matches carry `match_confidence = manual_verified` (rather than a numeric auto-match score), because they were originally flagged as low-confidence candidates in the UNMATCHED file and then confirmed by manual review:

| catalog86_name | matched_sku | matched_canonical_name |
|---|---|---|
| JuniorJoy | DJ-HEA-0111 | JuniorJoy - Kids Nutritional Drink (300g) |
| Ample Meal | DJ-HEA-0110 | Ample Meal - Meal Replacement Nutritional Shake (500g) |
| YumDum Himalayan Pink Salt | DJ-FOO-0013 | Himalayan Pink Salt Sprinkler (200g) |

## Outcome: 1 of 86 genuinely unmatched

`dayjoy_products_catalog_86items_UNMATCHED.csv` originally listed 4 low-confidence auto-match candidates. 3 of the 4 (above) were manually verified and moved into the matched set. The 4th was reviewed and **correctly declined**:

| catalog86_name | best_guess | score | reason |
|---|---|---|---|
| Neem & Aloevera Herbal Soap | Neem & Tulsi Herbal Soap (100g) (Pack of 3) | 0.916 | Auto-match scored 0.916 but is wrong on inspection — source ingredients are Neem+Aloe Vera, canonical product is Neem+Tulsi, a different formulation. No confident canonical match exists; declined to guess. May be a genuinely missing SKU. |

This is the reasoning already recorded in the UNMATCHED file itself — reproduced here, not re-derived.

## Outcome: 3 pricing conflicts flagged, not resolved

`catalog86_pricing_crosscheck_conflicts.csv` records 3 cases where the 86-item catalog's MRP disagrees with the canonical product master's MRP for the matched SKU. All 3 are marked `CONFLICT_UNRESOLVED` — flagged honestly rather than silently auto-resolved:

| product | catalog86_mrp | canonical_sku | canonical_name | canonical_mrp | note |
|---|---|---|---|---|---|
| Deep Cleansing Face Wash | 125 | DJ-PER-0053 | Deep Cleansing Face Wash (100ml) | 199 | 86-item catalog doesn't specify pack size; canonical has two variants (100ml @199, 60ml @ separate price) — 125 may belong to the 60ml variant. Needs verification, not auto-resolved. |
| Prosperous+ | 1499 | (Prosperous+ Tablets SKU) | Prosperous+ Tablets | 1049 | Real discrepancy, no obvious pack-size explanation. Needs verification against official price list. |
| Aqua Energiser | 9000 | DJ-AQU-0140 | Aqua Energiser (Single) | 3499 | Large discrepancy; 86-item catalog entry may refer to a bundle/kit not the single unit. Needs verification, not auto-resolved. |

These 3 conflicts remain **unresolved by design** — this document does not resolve them, only records that they were found and flagged. Any customer-facing price quote for these SKUs should be verified against an authoritative source before use.

## Summary

| Metric | Value |
|---|---|
| Catalog86 items total | 86 |
| Matched to canonical SKUs | 85 (91 rows incl. 6 bundle 1-to-2 matches) |
| Manually verified after initial low-confidence flag | 3 |
| Genuinely unmatched (declined) | 1 (Neem & Aloevera Herbal Soap) |
| Pricing conflicts found | 3 (all unresolved, flagged) |
