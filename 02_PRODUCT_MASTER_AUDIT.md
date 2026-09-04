# Phase 2 — Product Master Audit

Scope: `01_CANONICAL/products/dayjoy_product_master_canonical.csv` (170 product rows, 54 columns).
Audit performed 2026-08-09 by direct inspection of the CSV and its cross-referenced files (no data regenerated, nothing modified).

## Executive verdict: READY WITH FIXES

The pricing/identity backbone of this file (product_id, sku, mrp, dp, bv, pv) is complete, internally consistent, and traceable to named source documents — no invented data was found anywhere the file claims a source. The 86-vs-170 catalog conflict is genuinely resolved (85/86 matched, 1 correctly declined, 3 pricing conflicts correctly flagged rather than silently resolved) — but the evidence file the resolution is supposed to point to, `T001_CATALOG_MERGE_SUMMARY.md`, does not exist anywhere in the repository despite being cited three times (PRODUCTION_READINESS_REPORT.md, MISSING_DATA_TASKS.csv, and this audit's assigned brief). Separately, the entire "discovery layer" of this file — `description`, `faq_ids`, `image_ids`, `similar_product_ids`, `related_product_ids`, `unit`, `sub_category`, and six other relationship/marketing columns — is **100% empty across all 170 rows**, not partially populated. And the governance metadata meant to signal risk/confidence (`verification_status`, `approval_status`, `content_risk_level`, `pricing_risk_level`, `missing_content_fields_count`) is uniform across every single row, so it carries no discriminating signal — a known issue already flagged in `CLAIM_VERIFICATION_STANDARD.md`, confirmed here to also extend to a column that document doesn't mention (`missing_content_fields_count` = 4 for all 170 rows despite real, measured variance in the underlying content fields). None of this is invented or wrong data — it's absent data represented honestly as empty, which is why this is READY WITH FIXES rather than NOT READY.

---

## 1. Column inventory and mapping

| Requested column | Actual column(s) | Status | Notes |
|---|---|---|---|
| product_id | `product_id` | Exact match | 170/170 present, unique |
| sku | `sku` | Exact match | 170/170 present, unique |
| product_name | `product_name` | Exact match | 170/170 present |
| brand | `brand` | Exact match | 170/170 present, 10 distinct values |
| category | `category` | Exact match | 170/170 present, 12 distinct values |
| sub_category | `sub_category` | Column exists, **data missing** | 0/170 non-null — column is a header-only placeholder |
| pack_size | `pack_size` (+ `pack_size_alt_formatting`) | Exact match | 170/170 present, e.g. "200g", "500ml" |
| unit | `unit` | Column exists, **data missing** | 0/170 non-null. Unit is embedded inside the `pack_size` string instead (not split out) |
| mrp | `mrp` | Exact match | 170/170 present, numeric |
| dp | `dp` | Exact match | 170/170 present, numeric |
| bv | `bv` | Exact match | 170/170 present, numeric |
| pv | `pv` | Exact match | 170/170 present, numeric, always equals `bv` |
| currency | `currency` | Exact match | 170/170 present, uniformly "INR" |
| ingredients | `ingredients` | Exact match | 92/170 (54%) non-null — real gap, not missing column |
| benefits | `benefits` | Exact match | 133/170 (78%) non-null |
| usage | `usage` | Exact match | 22/170 (13%) non-null |
| dosage | `dosage` | Exact match | 98/170 (58%) non-null |
| warnings | `warnings` | Exact match | 1/170 (0.6%) non-null — near-total gap |
| contraindications | `contraindications` | Exact match | 1/170 (0.6%) non-null — near-total gap |
| certifications | `certifications` | Exact match | 7/170 (4%) non-null |
| manufacturer | `manufacturer` | Exact match | 170/170 present, but only 1 distinct value across the whole file |
| target_customer | `target_customer` | Exact match | 8/170 (4.7%) non-null |
| product_description | `description` | Renamed, **data missing** | 0/170 non-null |
| faq_ids | `faq_ids` (also a separate unused `faqs` column exists) | Exact match, **data missing** | 0/170 non-null |
| image_ids | `image_ids` | Exact match, **data missing** | 0/170 non-null |
| similar_product_ids | `similar_product_ids` | Exact match, **data missing** | 0/170 non-null |
| related_product_ids | `related_product_ids` (also a separate unused `related_products` column exists) | Exact match, **data missing** | 0/170 non-null |
| source_ids | `source_document_id` + `content_source_document` | Split into two columns | `source_document_id`: 170/170 present (single shared pricing-source string). `content_source_document`: 133/170 present, 37 null — all 37 nulls correspond to rows with no descriptive content (verified, no orphan case) |
| source_version | `source_version` | Exact match | 170/170 present, single value "2026-05-05" |
| verified_at | `last_verified` | Renamed | 170/170 present, single value "2026-05-05" |
| verification_status | `verification_status` | Exact match | 170/170 present, but **uniformly "approved"** — no differentiation (see §8) |
| confidence | `confidence` | Exact match | 170/170 present, but is a compound string ("verified_price_list \| High" / "verified_price_list \| nan"), not a numeric or meaningfully varying score (see §8) |

Columns present in the file but not in the requested list (extra, unused by this audit): `pack_size_alt_formatting`, `country`, `price_effective_date`, `pricing_confidence`, `features`, `storage`, `related_products`, `alternative_products`, `cross_sell_products`, `frequently_bought_together`, `search_keywords`, `faqs`, `approval_status`, `effective_from`, `effective_to`, `content_extraction_status`, `content_confidence`, `missing_pricing_governance_fields_count`, `missing_content_fields_count`, `pricing_risk_level`, `content_risk_level`. Of these, `related_products`, `alternative_products`, `cross_sell_products`, `frequently_bought_together`, `search_keywords`, and `faqs` are also **100% empty** (0/170) — the same relationship-data gap shows up under multiple redundant column names.

## 2. Uniqueness check

- `product_id`: 170/170 unique, 0 nulls, 0 duplicates.
- `sku`: 170/170 unique, 0 nulls, 0 duplicates.

Computed directly via pandas (`nunique()` == `len()` == 170 for both, `duplicated()` returns zero rows for both).

## 3. Duplicate product check

Exact match on `product_name` + `pack_size` (case/whitespace normalized): **0 duplicates**.
Exact match on `product_name` alone (ignoring pack size): **0 duplicates**.

Fuzzy check (SequenceMatcher similarity > 0.85, same 5-character name prefix) surfaced 34 near-identical name pairs, e.g. `DJP1043 Sanitary Pad (XL)` vs `DJP1044 Sanitary Pad (XXL)`, `DJP1006 Dhaniya Powder (200g)` vs `DJP1007 Dhaniya Powder (500g)`, `DJP1052 Deep Cleansing Face Wash (100ml)` vs `DJP1053 Deep Cleansing Facewash (60ml)`. Every one of these inspected is a legitimate distinct SKU (different pack size, strength, or language variant), not a data-entry duplicate. No genuine duplicate products found.

## 4. The 86-vs-170 catalog conflict: **RESOLVED, but its evidence file is missing**

Verified independently against `08_GOVERNANCE/source_registry/catalog86_merge_audit.csv` (91 rows / 85 unique `catalog86_name` values, 0 null `matched_sku`) and `01_CANONICAL/products/dayjoy_products_catalog_86items_UNMATCHED.csv`:

- **85 of 86** catalog items matched to canonical SKUs. 6 of the matches are 1-to-2 (bundle items like "Orthofix Tablet & Oil" matched to two canonical SKUs), which explains why the audit file has 91 rows for 85 unique source names.
- **1 of 86** genuinely unmatched: **"Neem & Aloevera Herbal Soap"**. The `UNMATCHED` file initially listed 4 low-confidence auto-match candidates (JuniorJoy, Ample Meal, YumDum Himalayan Pink Salt, Neem & Aloevera Herbal Soap); manual review subsequently confirmed 3 of the 4 (marked `manual_verified` in the audit trail) and correctly declined the 4th because the auto-match (0.916 similarity, "Neem & Tulsi Herbal Soap") was on a different formulation (Aloe Vera vs. Tulsi) — this is documented reasoning in the UNMATCHED file itself, not a guess.
- **3 pricing conflicts** were found during the merge (`Deep Cleansing Face Wash`, `Prosperous+`, `Aqua Energiser`) and are correctly flagged as unresolved in `catalog86_pricing_crosscheck_conflicts.csv` rather than silently overwritten — verified the referenced canonical SKUs (`DJ-PER-0053`, `DJ-AQU-0140`, and the two `Prosperous+` SKUs) all exist in the product master with the stated MRP values.

**Gap**: `01_CANONICAL/products/T001_CATALOG_MERGE_SUMMARY.md` — the primary evidence document this merge is supposed to be documented in — **does not exist** in the repository (confirmed via directory listing and repo-wide filename search). It is cited as evidence in `PRODUCTION_READINESS_REPORT.md` line 9 and `09_QA/MISSING_DATA_TASKS.csv` (T001 row) but the file itself is absent. The underlying merge is real and auditable via the CSVs above, so the *conclusion* is trustworthy, but the *stated evidence trail* has a broken link.

## 5. Source traceability

- `source_document_id`: 170/170 rows populated with `"India-BV-Price-May-2026 + approved Dayjoy sources"`. The underlying file `India BV Price May 2026.pdf` exists at `00_SOURCE_DOCUMENTS/price_lists/` — traceable, though the id string uses a different format (dashes) than the real filename (spaces), a cosmetic mismatch not a broken link.
- `content_source_document`: 133/170 populated, 37 null. All 37 nulls correspond exactly to rows with no ingredients/benefits/usage/dosage content — **0 rows found with factual content and no source reference** (checked explicitly: any row with non-null ingredients/benefits/usage/dosage always has a non-null `content_source_document`). No evidence of invented/unsourced factual content.
- **Broken filename reference**: 130 of 170 rows (87+41+2) cite `"Dayjoy Product Brochure - English July2026_11zon_2.pdf"` as a source. The actual file in `00_SOURCE_DOCUMENTS/brochures/` is named `"Dayjoy Product Brochure - English July2026_11zon.pdf"` — no `_2` suffix, confirmed via repo-wide filename search (zero hits for any `*11zon_2*` file). The document almost certainly is the same brochure (an artifact of the extraction pipeline naming), but as written the citation does not resolve to an existing filename.
- The original 86-item catalog file (`Dayjoy_Products_Catalog.csv`) cited in 91 rows is not present in `00_SOURCE_DOCUMENTS/` but is traceable through `08_GOVERNANCE/source_registry/file_inventory.csv` (4 historical copies logged with file IDs F00237/F00241/F00261/F01798), so the citation is recoverable, just not to a file preserved in the canonical source folder.

## 6. Null vs. invented check

Spot-checked all 37 rows missing ingredients+benefits+dosage simultaneously (sampled 10) — all genuinely `NaN`, not placeholder text. Examples: `DJP1150 Dayjoy Bike Sticker`, `DJP1146 Dayjoy Diary`, `DJP1125 Nano Tech-46 (500ml)`, `DJP1168 AGRI STARTER PACKAGE` — these are merchandise, print collateral, and agri-inputs where the absence of ingredients/dosage is expected, not a data-loss artifact.

Ran a regex sweep for placeholder patterns (`n/a`, `tbd`, `todo`, `placeholder`, `not available`, `unknown`, `lorem ipsum`, `coming soon`) across all 8 content-bearing columns (`ingredients`, `benefits`, `usage`, `dosage`, `warnings`, `contraindications`, `certifications`, `target_customer`): **0 matches**. No fake/placeholder content masquerading as real data was found.

## 7. Relationship integrity

**faq_ids, image_ids, similar_product_ids, related_product_ids are 0/170 populated — there is nothing to parse or resolve.** This is not an orphan-reference problem (broken links); it's a total absence of forward links from the product master. Cross-checking the referenced files directly:

- **FAQ**: `01_CANONICAL/faq/dayjoy_faq_combined_canonical.csv` has 1,884 rows with its own `product_id`/`sku` columns, covering all 170 products (170/170 distinct product_id and sku values present). The relationship *exists* and is fully joinable by `product_id`/`sku`, but only in the reverse direction (FAQ → product); the product master's own `faq_ids` column that should hold the forward pointer is empty.
- **Images**: `06_IMAGES/metadata/dayjoy_image_metadata_CANONICAL.csv` has 120 rows covering 108 distinct SKUs (of 170, i.e. 63.5% of products have any image record at all — 62 SKUs have none). Of those 120 metadata rows, only **30 (25.0%)** have an `image_path` that resolves to a real file in `06_IMAGES/products/` — the other 90 (75.0%) are broken paths. Root cause: the metadata consistently references `_1`, `_2`, `_3` suffixed filenames (e.g. `DJ-AGR-0124_1.webp`), while the actual files on disk use different suffix numbering or no suffix at all (e.g. `DJ-AGR-0124.webp` exists, `DJ-AGR-0124_1.webp` does not). This is a genuine broken-link problem in the image metadata file itself, independent of the product master's empty `image_ids` column, and would need fixing before `image_ids` could even be safely backfilled.
- **similar_product_ids / related_product_ids**: no target file was identified in the repo that stores a canonical similar/related-product graph to check against (`02_RELATIONSHIPS/product_relationships/` exists as a folder — not inspected in depth as out of this audit's stated scope, but worth noting the product master doesn't populate these columns from whatever is there, if anything).

Orphan rate cannot be meaningfully computed for any of these four columns because the columns contain no values to check — 0% coverage, not partial-with-orphans.

## 8. Verification status meaningfulness: **not differentiated — rubber-stamped**

Confirmed and extended the known inconsistency documented in `08_GOVERNANCE/verification/CLAIM_VERIFICATION_STANDARD.md` (§"Known inconsistency"):

| Field | Distribution across 170 rows |
|---|---|
| `verification_status` | `approved` — 170/170 (100%), zero variation |
| `approval_status` | `approved` — 170/170 (100%), zero variation |
| `content_risk_level` | `high` — 170/170 (100%), zero variation |
| `pricing_risk_level` | `low` — 170/170 (100%), zero variation |
| `source_version` / `effective_from` / `last_verified` | single date "2026-05-05" — 170/170, zero variation |
| `missing_content_fields_count` | `4` — 170/170, zero variation, **despite measured real variance** in the underlying content fields (ingredients 92/170, benefits 133/170, usage 22/170, dosage 98/170 populated) — this counter does not track actual per-row completeness and should not be trusted as a QA signal |
| `confidence` | not numeric — a compound string: `"verified_price_list \| High"` (131/170) or `"verified_price_list \| nan"` (39/170). Only 2 distinct patterns, driven entirely by whether `content_confidence` is null, i.e. it's a re-encoding of `content_extraction_status`, not an independent confidence measure |

The governing document's rule — "when both fields are present, `content_risk_level` wins for anything touching health, dosage, ingredients, or usage" — is a sound operational workaround, but it means `verification_status = approved` must be read by any downstream consumer as "approved for catalog inclusion" only, never as "content verified." Any integration that reads `verification_status` at face value would incorrectly treat all 170 rows' health/ingredient claims as verified.

## 9. Internal price consistency

Checked all 170 rows for `mrp`, `dp`, `bv`, `pv`:

- `dp > mrp`: **0 rows** (no violations).
- `bv > dp`: **0 rows** (no violations).
- `mrp <= 0` or `dp <= 0`: **0 rows**.
- `pv != bv`: **0 rows** — `pv` equals `bv` on every single row (consistent MLM point-value convention).
- `bv/dp` ratio ranges 0.0–0.55 (mean 0.29) — plausible commission-base range.
- `dp == mrp` (no distributor discount) on 18 rows, and `bv == 0` on 19 rows: all of these are non-BV promotional/merchandise/print items (Dayjoy Cap, Mug, Bike Sticker, Diary, brochures, leaflets, business planner books) — a coherent, explainable pattern (merchandise doesn't carry a distributor margin or BV), not a pricing error.

No internal price inconsistencies found.

## 10. Verdict: READY WITH FIXES

**Justification:**
- What's solid: identity fields (product_id/sku) are unique and complete; pricing fields are internally consistent with zero logical violations; the headline "86 vs 170" conflict is genuinely resolved with a real audit trail and honest unresolved-conflict flagging; no invented content or placeholder text was found anywhere; source citations exist for all content that's present (no orphan factual claims); safety classification has full 170/170 SKU coverage.
- What blocks a clean READY: (a) the relationship/discovery layer (`faq_ids`, `image_ids`, `similar_product_ids`, `related_product_ids`, `description`, plus 6 more columns) is completely unpopulated — any AI system reading this file directly for those fields gets nothing; (b) the image metadata that *would* back-fill `image_ids` is itself 75% broken by filename mismatch; (c) verification/risk governance columns are uniform rubber stamps, not real signals, which is already flagged in existing governance docs but worth re-confirming still holds; (d) the T001 merge's own named evidence file doesn't exist, weakening the audit trail even though the conclusion checks out independently.
- None of these are data-fabrication problems — they are honest gaps (empty is empty, not filled with guesses) — which is why this is READY WITH FIXES rather than NOT READY.

---

## Gap list

1. `T001_CATALOG_MERGE_SUMMARY.md` cited as evidence in 2+ places but does not exist in the repo.
2. `faq_ids`, `image_ids`, `similar_product_ids`, `related_product_ids`, `description`, `unit`, `sub_category` — all 0/170 populated in the product master.
3. Six additional redundant relationship/marketing columns (`related_products`, `alternative_products`, `cross_sell_products`, `frequently_bought_together`, `search_keywords`, `faqs`) also 0/170 populated.
4. `06_IMAGES/metadata/dayjoy_image_metadata_CANONICAL.csv`: 90/120 rows (75%) have an `image_path` that doesn't resolve to a real file on disk (suffix-numbering mismatch).
5. 62/170 SKUs (36.5%) have no image record at all, even in the metadata file.
6. Content source citation `"...11zon_2.pdf"` referenced by 130/170 rows doesn't match the actual filename on disk (`"...11zon.pdf"`, no `_2`).
7. `verification_status`, `approval_status`, `content_risk_level`, `pricing_risk_level`, `missing_content_fields_count` are uniform across all 170 rows and cannot be used as row-level QA/risk signals.
8. `confidence` is a compound string, not a real numeric/graded confidence score.
9. `warnings` (1/170) and `contraindications` (1/170) are populated on essentially no rows — a content gap for anything with a safety angle, worth flagging alongside `08_GOVERNANCE/safety/dayjoy_product_safety_classes.csv`'s 50 `regulated_product`-classified SKUs.
10. 3 unresolved pricing conflicts from the 86-item merge remain genuinely unresolved (by design, correctly flagged, not a defect — listed here for completeness).

## Recommended fixes (non-destructive, not applied)

1. Locate or reconstruct `T001_CATALOG_MERGE_SUMMARY.md`, or update the citing documents (`PRODUCTION_READINESS_REPORT.md`, `MISSING_DATA_TASKS.csv`) to point at the CSVs that actually substantiate the claim (`catalog86_merge_audit.csv`, the UNMATCHED/conflicts CSVs).
2. Populate `faq_ids` on the product master by joining `dayjoy_faq_combined_canonical.csv` on `product_id`/`sku` and aggregating `faq_id` — the data to do this already exists, it just isn't propagated forward.
3. Fix the filename/suffix mismatch in `dayjoy_image_metadata_CANONICAL.csv` (map metadata rows to actual files in `06_IMAGES/products/` by SKU prefix + content hash rather than assumed suffix), then populate `image_ids` from the corrected metadata.
4. Correct the `content_source_document` citation from `"...11zon_2.pdf"` to the real filename `"...11zon.pdf"`.
5. Either compute `similar_product_ids`/`related_product_ids` from `02_RELATIONSHIPS/product_relationships/` (if suitable data exists there — not verified in this audit) or explicitly document them as not-yet-populated rather than leaving them silently empty.
6. Consider adding a row-level completeness or risk field that actually varies (the existing `missing_content_fields_count` does not), so downstream consumers get a real per-product signal instead of a constant.
7. Resolve the 3 outstanding pricing conflicts against an authoritative source before those 3 SKUs are used in any customer-facing price quote.

---

## Stakeholder summary (under 15 lines)

Product master (170 SKUs, 54 columns) passes on identity and pricing: no duplicate IDs/SKUs, no pricing logic errors, no invented content anywhere checked. The 86-vs-170 catalog conflict is genuinely resolved — 85/86 items merged, 1 correctly declined, 3 pricing conflicts honestly flagged as unresolved rather than guessed — though the summary document that's supposed to prove this doesn't actually exist in the repo (the underlying CSVs do, and confirm the claim independently). The bigger issue: the file's entire relationship layer — FAQ links, image links, similar/related product links, and product descriptions — is 100% empty across all 170 rows, not partially filled. Image metadata that could fill that gap is itself 75% broken (wrong filenames). Verification/risk-status columns are rubber-stamped identically on every row and cannot be used to tell a well-verified product from a poorly-verified one — a known issue, now confirmed to extend further than previously documented. Nothing here suggests fabricated data; it's an honestly-empty file in several places that reads as "complete" at a glance but isn't. Verdict: READY WITH FIXES.
