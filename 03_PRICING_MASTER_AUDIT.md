# Phase 3 — Pricing Master Audit

**Scope:** `01_CANONICAL/pricing/*` and the pricing-relevant columns of `01_CANONICAL/products/dayjoy_product_master_canonical.csv`.
**Audit type:** Strict, read-only. No files were modified, moved, or deleted. All numbers below were computed directly from the files in the repo, not taken from prior notes.
**Date of audit:** 2026-08-09

---

## Executive Verdict: **READY WITH FIXES**

The good news first, because it changes the risk profile of this audit: where the two pricing representations can actually be compared (`dayjoy_price_list_may2026.csv` vs. the embedded pricing in `dayjoy_product_master_canonical.csv`), **mrp and dp agree on all 170 products with zero mismatches**, and bv agrees on all 151 products where the standalone pricing file has a bv value at all. The JSON and SQL exports are byte-for-byte consistent with the CSV they were derived from — no independent drift found there. That is a materially stronger starting position than the "two disagreeing sources of current price" scenario this audit was designed to catch.

However, the file cannot yet serve as a usable "pricing master" in the shape requested (product_id, sku, product_name, mrp, dp, bv, pv, effective_from, effective_to, currency, source_id, verified) for three structural reasons: (1) `sku` is 0% populated in the standalone pricing file, so it cannot be joined to anything by SKU — only by product name — which is a fragile, easily-broken join key; (2) `pv` is 0% populated in the standalone pricing file even though it exists in the header and is fully populated in the product master, meaning the "master" pricing file is missing a field the business master requires; (3) there is no `effective_to`/price-history mechanism anywhere in the repo — only a single current price is ever stored, so "retain old prices but don't let them override current" is not a capability that exists today, it would need to be built. A separate, already-known-bad file (`dayjoy_price_list_extracted_from_pdf.csv`) sits in the same folder with no label marking it superseded, which is a real trap for anyone who picks the wrong file by filename alone. None of this is a pricing *disagreement* — it's a schema/completeness/labeling gap. That's why the verdict is READY WITH FIXES rather than NOT READY.

---

## 1. Column Mapping Table

Target schema: `product_id, sku, product_name, mrp, dp, bv, pv, effective_from, effective_to, currency, source_id, verified`

| Requested column | Actual column in `dayjoy_price_list_may2026.csv` | Status |
|---|---|---|
| `product_id` | — | **Missing.** No such column exists. Verified directly against the header: `source_product_no, product_name, category, mrp_inr, dp_inr, bv, pv, pack_size, sku, ingredients, benefits, usage, dosage, warnings, certifications, product_image_url, source_file, source_page, effective_date, confidence, data_status`. There is a `source_product_no` (1–170, sequential) but it is not a stable product ID — it's a row/line number from the PDF table. |
| `sku` | `sku` | **Present as a column, but empty.** See Section 2 — 0/170 rows populated. |
| `product_name` | `product_name` | Present, populated 170/170. |
| `mrp` | `mrp_inr` | Renamed (currency suffix baked into name), populated 170/170. |
| `dp` | `dp_inr` | Renamed, populated 170/170. |
| `bv` | `bv` | Present, populated 151/170 (19 rows blank — see Section 7). |
| `pv` | `pv` | Present as a column, but **0/170 populated** — see Section 2/7. |
| `effective_from` | `effective_date` | Renamed, single value `2026-05-05` for all 170 rows. |
| `effective_to` | — | **Missing.** No such column, no equivalent concept anywhere in the pricing file. Confirmed directly against the header list above. |
| `currency` | — (implicit) | Not a column in this CSV; currency is baked into the `mrp_inr`/`dp_inr` column names and stated once in the JSON's `source.currency = "INR"` and the SQL header comment. The product master, by contrast, does have an explicit `currency` column (see Section 7). |
| `source_id` | `source_file` + `source_page` | Renamed/split: `source_file` = `India-BV-Price-May-2026.pdf` (170/170 populated), `source_page` = `1-4` (170/170 populated, same value for every row — a range, not a resolvable single page). |
| `verified` | `confidence` + `data_status` | Renamed/approximated: `confidence = "high"` for all 170 rows; `data_status` is a fixed narrative string for all 170 rows ("Price list verified; detailed product specification not provided in price-list source."). Not a boolean `verified` flag, but functionally the closest analog. |

**Additional columns present but out of scope for the requested schema:** `category`, `pack_size`, `ingredients`, `benefits`, `usage`, `dosage`, `warnings`, `certifications`, `product_image_url` — all of these are **0/170 populated** (empty) in this pricing file. Noted for completeness since they bear on how "rich" this file actually is beyond price fields, but not part of the requested pricing-master schema.

---

## 2. SKU / product_id Linkage Check — STRUCTURAL DEFECT

Computed directly on all 170 data rows of `dayjoy_price_list_may2026.csv`:

**sku populated: 0 / 170 rows (0%).**

Every single `sku` cell is an empty string. This is confirmed in the CSV, the JSON (`sku: null` for all 170 product objects), and the SQL (the `sku` column exists in the `CREATE TABLE` statement but is never included in any of the 170 `INSERT` column lists, so it is NULL for every row in all three representations).

There is also no `product_id` column in this file at all (see Section 1).

**This means `dayjoy_price_list_may2026.csv` cannot be joined to `dayjoy_product_master_canonical.csv` (or to any other file) by `sku` or by `product_id`.** The only viable join key found during this audit is `product_name`, after normalizing case/punctuation/whitespace — and even that only works because, by coincidence of construction, both files preserve the same 170-row ordering (verified in Section 4). Name-based joins are inherently fragile (typos, renames, pack-size formatting differences like "200g" vs "(200g)" already had to be normalized past). State this precisely: **the pricing file has no durable foreign key to the product catalog today.** This is a structural defect, not a "needs review" item — a downstream system cannot reliably resolve "this SKU's current price" from this file as-is.

---

## 3. Row Count Reconciliation — 170 vs. ~138

- `dayjoy_price_list_may2026.csv`: **170 data rows** (confirmed by direct count).
- `dayjoy_price_list_extracted_from_pdf.csv`: **138 data rows** (confirmed by direct count), columns `sno, product_name, mrp, distributor_price, bv, normalized_name` — notably no `pv`, `pack_size`, `sku`, or any of the descriptive fields.
- `dayjoy_product_master_canonical.csv`: **170 rows**, matching the 170-row file.

**Root cause, verified directly:** `dayjoy_price_list_extracted_from_pdf.csv` is a **corrupted/lower-quality earlier extraction pass**, not a genuinely different pricing source. Its `sno` field runs to 171 (implying it originally targeted the same 170–171 products) but only 138 rows survive, because the PDF-table extraction merged the text of adjacent table rows into single cells in a number of places. Concrete evidence found in the file itself:

- Row `sno=63` has `product_name = "AcneX Anti- Acne Foaming Cleanser (100ml) 399 299 98 (D) COLOR COSMETICS 64 Amara Beauty Kajal"` — the price/BV numbers and the *next* product's category header and name got swallowed into this one field, and `sno=64` is simply missing (skipped).
- Row `sno=65` similarly swallows "(E) HEALTH CARE 66 Asthprash (300 grams)" into the `product_name` field for "Amara Beauty Eyeliner," and `sno=66` is missing.
- The tail of the file (`sno=157`–`164` region) has one row's `product_name` field containing a run-on string with ~10 product names, prices and sno numbers concatenated together ("...148 dayjoy diary 299 275 149 dayjoy leather bag...").
- **The mrp/dp/bv values are also wrong for rows adjacent to a merge**, not just the names: `sno=63`'s stored mrp/dp/bv (299/199/65) are actually Amara Beauty Kajal's true values (verified against the clean 170-row file: Amara Beauty Kajal = 299/199/65, AcneX = 399/299/98). So this file doesn't just have fewer rows — some of the rows it does have carry another product's price data under the wrong name.

Where rows are clean (the bulk of the file, e.g., "PREMIUM PACKAGE" = 17592/10499/5000 in both files), the values do match the 170-row file. But given the demonstrated corruption pattern, **`dayjoy_price_list_extracted_from_pdf.csv` should be treated as a superseded, defective draft extraction and not used for anything.** It is not currently labeled as superseded anywhere in the repo (it sits in `01_CANONICAL/pricing/` alongside the good file with no README or status note distinguishing them) — this labeling gap is a real risk (see Gap List).

---

## 4. Price Agreement Check — join by normalized product_name (170/170 rows aligned)

**Join method used:** `dayjoy_price_list_may2026.csv` and `dayjoy_product_master_canonical.csv` were joined by normalized `product_name` (lowercased, punctuation stripped). This also happens to line up 1:1 by row position for all 170 rows (verified: 0 order mismatches after normalization), which corroborates that both files were built from the same underlying 170-item sequence — but name-normalization was still required because raw strings differ (e.g., `"Black Salt Sprinkler 200g"` vs `"Black Salt Sprinkler (200g)"`).

Results, computed field-by-field across all 170 rows:

| Field | Rows compared | Real value mismatches |
|---|---|---|
| `mrp_inr` vs `mrp` | 170 | **0** |
| `dp_inr` vs `dp` | 170 | **0** |
| `bv` vs `bv` | 170 | **0** mismatches where both files have a value; **19 rows** where the pricing CSV's `bv` is blank but the product master has a value (not a disagreement, a gap — see Section 7) |
| `pv` vs `pv` | 170 | Not comparable — pricing CSV's `pv` is blank for **all 170 rows**; product master has `pv` populated for all 170. This shows up as "170 mismatches" in a naive diff, but it is really one structural gap (pricing file never populates `pv`), not 170 independent factual disagreements. |

**Bottom line for cross-validation: 0 mrp mismatches, 0 dp mismatches, 0 bv mismatches (on the 151 rows where both files have a bv value).** No product in this repo currently has two disagreeing "current price" numbers between the standalone pricing file and the product master's embedded pricing. The only disagreement-shaped issue is a completeness gap (bv missing for 19 rows, pv missing for all 170 rows in the pricing CSV only), not a conflicting-values problem.

This is a materially different — and better — finding than the audit brief's working hypothesis. State it plainly rather than manufacturing conflicts that were not found.

---

## 5. Effective Dating — No price history capability exists today

Checked both files directly:

- `dayjoy_price_list_may2026.csv`: single `effective_date` column, value `2026-05-05` for all 170 rows. No prior/alternate date ever appears.
- `dayjoy_product_master_canonical.csv`: has both `effective_from` (all rows = `2026-05-05`) and `effective_to` (all rows = **empty**), plus `price_effective_date` (also `2026-05-05` for all rows).

There is exactly one price row per product in every representation checked (CSV, JSON, SQL, product master). No archived/prior-version pricing rows were found for any product in `01_CANONICAL/`. (The SQL file's `INSERT ... ON CONFLICT (source_product_no) DO UPDATE` pattern is explicitly an **upsert-in-place** design — a re-run with new prices would overwrite the existing row, not create a new dated row.)

**Conclusion: only a single "current" price is stored anywhere. There is no historical retention mechanism.** "Old prices retained historically but cannot override current" is not something this schema can do today — `effective_to` exists as a column in the product master but is never populated, and the upsert logic in the SQL would actively destroy history if it were ever populated, since it updates by `source_product_no` rather than inserting a new versioned row.

---

## 6. Authority Check — Undocumented

Searched `08_GOVERNANCE/` (source_registry, verification, audit) and repo-root/folder READMEs for any explicit statement that `dayjoy_price_list_may2026.csv` (vs. the extracted-from-pdf file, vs. the product master's embedded pricing) is the designated highest-authority current source.

**Finding: no such statement exists.** What was found:
- `08_GOVERNANCE/audit/MISSING_KNOWLEDGE.md` line 7 says pricing was "verified against `India BV Price May 2026.pdf`" for the 170-SKU catalog — this establishes the PDF as the root source, but does not rank the three *downstream* pricing representations (standalone CSV/JSON/SQL vs. product-master-embedded columns) against each other.
- `08_GOVERNANCE/audit/DUPLICATE_REPORT.md` documents an unrelated-but-parallel authority conflict between two *other* product-master pipelines (one with pricing filled, one without) and explicitly flags it as needing human reconciliation — the same kind of decision this pricing question needs, but it does not cover the pricing files themselves.
- No file in `08_GOVERNANCE/source_registry/` or `01_CANONICAL/pricing/` states "use file X, not file Y" for pricing.

Given that this audit found mrp/dp/bv values *agree* between the standalone file and the product master (Section 4), the lack of a documented authority ranking is lower-stakes than it would otherwise be — but it is still undocumented, and should be fixed before a third pricing-touching pipeline is added, since the current agreement is empirical (this audit checked it) rather than guaranteed by any process.

---

## 7. Currency Standardization

- `dayjoy_price_list_may2026.csv`: no explicit `currency` column; currency is embedded in column names (`mrp_inr`, `dp_inr`) and stated once in the JSON `source.currency` field and the SQL header comment, both = `"INR"`.
- `dayjoy_price_list_may2026.json`: `source.currency = "INR"`, consistent, single value, applies to all 170 products.
- `dayjoy_price_list_may2026_supabase.sql`: header comment states "INR"; no `currency` column in the `CREATE TABLE dayjoy_products` schema at all — currency is implicit/undeclared at the row level.
- `dayjoy_product_master_canonical.csv`: **has an explicit `currency` column, checked directly: single unique value `INR` across all 170 rows.** No mixed or missing currency values found.

**Conclusion: currency is consistently INR everywhere it is checkable**, but the standalone pricing file/SQL schema don't carry currency as an explicit per-row field the way the product master does — if this pricing file is ever used outside an INR-only context, that's a latent gap, not an active defect today.

**Secondary finding (bv gap):** `bv` is populated for 151/170 rows in the pricing CSV (empty for 19 rows) but populated for all 170 rows in the product master (with `0` for items like leaflets, brochures, and merchandise that logically carry no BV). The product master appears to be the more complete source for `bv`.

---

## 8. Source Traceability

Checked `source_file` and `source_page` on all 170 rows of `dayjoy_price_list_may2026.csv`:

- `source_file`: **170/170 populated**, single value `India-BV-Price-May-2026.pdf` for every row.
- `source_page`: **170/170 populated**, single value `1-4` (a page range) for every row — not resolved to an individual page per product.
- The referenced PDF (`India BV Price May 2026.pdf`, note the space-vs-hyphen filename difference between the actual file on disk and the string stored in `source_file`) **does exist in the repo** at `01_CANONICAL/pricing/India BV Price May 2026.pdf` (1.89 MB, confirmed present).

So every row does cite a real, present source file, but at coarse granularity (a 4-page range applied uniformly, not a specific page or table row per product) and with a filename-formatting mismatch between the citation string and the actual file on disk (harmless for a human but would break an automated file-existence check that does exact string matching).

---

## Gap List

1. **`sku` is 0% populated** in `dayjoy_price_list_may2026.csv` (CSV, JSON, and SQL all confirm this) — no SKU-based join to the product master is possible today.
2. **No `product_id` column** in the pricing file at all.
3. **`pv` is 0% populated** in the pricing file despite existing as a column and being fully populated in the product master — an unexplained asymmetry between two files that are otherwise well aligned.
4. **No `effective_to` / price-history mechanism** anywhere — single current-price-only model; the SQL upsert pattern would overwrite, not version, if re-run.
5. **`dayjoy_price_list_extracted_from_pdf.csv` is a corrupted, superseded draft** (row-merging OCR/table-extraction errors, ~32 products lost or corrupted) sitting unlabeled in the same folder as the good file — real risk of being picked up by mistake.
6. **No documented authority ranking** between the standalone pricing file, the extracted-from-pdf file, and the product master's embedded pricing.
7. **19/170 rows missing `bv`** in the pricing CSV where the product master has a value.
8. **`source_page` is a coarse 4-page range**, not a per-product page citation; `source_file` string (`India-BV-Price-May-2026.pdf`) doesn't exactly match the actual filename on disk (`India BV Price May 2026.pdf`).
9. **No explicit `currency` column** in the standalone pricing CSV or the SQL schema (product master has one; standalone file relies on column-name suffixes and one JSON field).
10. Descriptive columns in the pricing file (`ingredients`, `benefits`, `usage`, `dosage`, `warnings`, `certifications`, `product_image_url`) are **0% populated** — not a pricing defect per se, but relevant if anyone assumes this file is a richer product record than it is.

## Prior-documented conflicts referenced (not rediscovered from zero)

`01_CANONICAL/products/catalog86_pricing_crosscheck_conflicts.csv` already documents 3 unresolved pricing conflicts between an 86-item catalog and the canonical product master (Deep Cleansing Face Wash pack-size ambiguity, Prosperous+ Tablets MRP discrepancy ₹1499 vs ₹1049, Aqua Energiser ₹9000 vs ₹3499 likely bundle-vs-single). These are separate from the May-2026 price list vs. product-master comparison done in Section 4 above, and remain marked `note: "Needs verification, not auto-resolved"` — no `status=CONFLICT_UNRESOLVED` column is present in that file the way `dayjoy_compensation_conflicts.csv` uses one, so **pricing conflicts do not fully follow the same documented pattern established for compensation conflicts** (compensation conflicts use `field, existing_kb_value, authoritative_pdf_value, source_document, source_page, recommended_action, status=CONFLICT_UNRESOLVED`; the pricing conflict file uses a narrower, less structured `product, catalog86_mrp, canonical_sku, canonical_name, canonical_mrp, note` schema with no explicit status field).

---

## Recommended Fixes (non-destructive, for human sign-off — not applied)

1. Populate `sku` in `dayjoy_price_list_may2026.csv`/json/sql by joining to `dayjoy_product_master_canonical.csv` on normalized product_name (this audit already established a clean 1:1 name match for all 170 rows) — but have a human spot-check the join before treating it as final, since name-matching is inherently softer than an ID match.
2. Add a `product_id` column to the pricing file, populated the same way, once the sku backfill above is verified.
3. Either populate `pv` in the standalone pricing file from the product master (values already exist and agree with mrp/dp there) or document why the standalone file intentionally omits it.
4. Move or clearly label `dayjoy_price_list_extracted_from_pdf.csv` as superseded/do-not-use (e.g., relocate to `99_ARCHIVE/superseded/` with a note, or add a header/README in `01_CANONICAL/pricing/` naming the May-2026 CSV as authoritative). Do not delete it — it may still have forensic value.
5. Add an explicit authority statement (e.g., in `08_GOVERNANCE/source_registry/`) naming `dayjoy_price_list_may2026.csv` (or the product master, whichever the team decides) as the single source of truth for current pricing, and defining how the other representations (JSON/SQL/product-master-embedded) are meant to derive from it.
6. If price history is a real business requirement, design a proper versioned table (e.g., `price_id, product_id, mrp, dp, bv, pv, effective_from, effective_to, source_id`) rather than relying on the current single-row-per-product upsert pattern — this is a schema addition, not a data fix.
7. Backfill the 19 missing `bv` values in the pricing CSV from the product master (values already agree elsewhere, so this is likely a safe copy, but confirm with a human before writing).
8. Fix the `source_file` string in the pricing CSV/JSON/SQL to exactly match the on-disk filename, or vice versa, so automated existence checks don't false-fail.
9. Bring the pricing-conflicts file up to the same structured `status`-flagged pattern used in `dayjoy_compensation_conflicts.csv` for consistency across the KB.

None of the above were applied. All pricing values remain exactly as found.

---

## Stakeholder Summary (under 15 lines)

Phase 3 Pricing Master is **READY WITH FIXES**. The core numbers actually agree: mrp, dp, and bv match with **zero mismatches** between the standalone May-2026 pricing file and the product master's embedded pricing across all 170 products — there is no live "two disagreeing prices" problem today. But the file can't yet function as a real pricing master: `sku` is **0% populated** (0/170), so nothing can join to it by SKU or product_id, only by product name; `pv` is likewise 0% populated in the pricing file even though the product master has it; and there's no `effective_to`/price-history capability anywhere, so no old prices are retained, only the single current price. A second file, `dayjoy_price_list_extracted_from_pdf.csv` (138 rows), is a corrupted, superseded draft extraction with row-merging errors that scrambled some products' prices — it sits unlabeled next to the good file and should be clearly marked do-not-use. JSON and SQL exports are fully consistent with the source CSV, no drift found. Source citations exist for every row but are coarse (a 4-page range, not per-product). Currency is consistently INR everywhere. Recommend: backfill sku/product_id via the verified name-join, decide and document which file is authoritative, and design real price versioning before this claims production-ready status.
