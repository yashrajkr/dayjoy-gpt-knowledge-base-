# Pricing Authority Statement

## Purpose

`03_PRICING_MASTER_AUDIT.md` (repo root, audit dated 2026-08-09) found that no explicit statement existed anywhere in this repository naming which of the three current pricing representations — the standalone pricing CSV, the older extracted-from-PDF CSV, or the product master's embedded pricing columns — is authoritative. This document is that missing statement, written directly from that audit's findings.

## Authoritative source

**`01_CANONICAL/pricing/dayjoy_price_list_may2026.csv`, and its derived `dayjoy_price_list_may2026.json` and `dayjoy_price_list_may2026_supabase.sql` exports, are the designated authoritative representation of current Dayjoy pricing** (MRP, DP, BV, PV) for all 170 canonical products.

The JSON and SQL exports were confirmed by `03_PRICING_MASTER_AUDIT.md` to be byte-for-byte/value-consistent with the CSV they were derived from — no independent drift was found between the three formats. They may be used interchangeably depending on integration needs, but all three trace back to the same source data and the same underlying source document: `India BV Price May 2026.pdf` (registered in `source_registry.csv` as `F00031`, tier 1).

## Do not use: the superseded draft extraction

**`01_CANONICAL/pricing/dayjoy_price_list_extracted_from_pdf.csv` is a superseded, defective draft extraction and must not be used.**

Per `03_PRICING_MASTER_AUDIT.md` Section 3:
- It contains only 138 data rows, versus 170 in the authoritative file, despite its own `sno` field running to 171 (implying it originally targeted the same product set).
- Rows were lost or corrupted by a PDF-table extraction defect that merged the text of adjacent table rows into single cells. Documented examples include `sno=63`, whose `product_name` field swallowed the price/BV numbers and the next product's category header and name, with `sno=64` skipped entirely; and a run of rows near `sno=157`–`164` where roughly 10 product names, prices, and row numbers were concatenated into one field.
- Where rows were merged, the numeric values were also corrupted, not just the names: `sno=63`'s stored mrp/dp/bv (299/199/65) actually belong to a different product (Amara Beauty Kajal), while the correct values for the row's nominal product (AcneX) are 399/299/98, per the authoritative file.
- It was not labeled as superseded anywhere in the repository prior to this statement — it sits in the same folder as the authoritative file with no distinguishing marker, which the audit flagged as a real risk of accidental use.

## Independent verification: product master agreement

`03_PRICING_MASTER_AUDIT.md` (Section 4) independently cross-checked the authoritative standalone pricing file against the pricing columns embedded in `01_CANONICAL/products/dayjoy_product_master_canonical.csv`, joining on normalized `product_name` across all 170 rows (0 order mismatches after normalization). Result, **as of the audit date 2026-08-09**:

- `mrp_inr` vs. `mrp`: **170/170 rows compared, 0 mismatches.**
- `dp_inr` vs. `dp`: **170/170 rows compared, 0 mismatches.**
- `bv` vs. `bv`: **0 mismatches** on the 151 rows where both files have a populated `bv` value. (The remaining 19 rows are a completeness gap — the standalone pricing file leaves `bv` blank where the product master has a value — not a value disagreement.)
- `pv`: not comparable — the standalone pricing file has `pv` blank for all 170 rows, while the product master has `pv` populated for all 170. This is a structural completeness gap in the standalone file (it never populates `pv`), not 170 independent factual disagreements.

**Zero mismatches were found between the two representations on every field where both files actually carry a value**, as of 2026-08-09. No product in this repository currently has two disagreeing "current price" numbers between the standalone pricing file and the product master's embedded pricing.

## Caveats carried forward from the audit (not resolved by this statement)

This statement establishes authority; it does not fix the structural gaps `03_PRICING_MASTER_AUDIT.md` also documented in the authoritative file itself:
- `sku` is 0% populated (0/170) in `dayjoy_price_list_may2026.csv` — it cannot be joined to the product master by SKU or product_id today, only by normalized product name.
- `pv` is 0% populated in the standalone file despite existing as a column.
- No `effective_to`/price-history mechanism exists anywhere in the repo — only a single current price is stored per product, and the SQL's upsert pattern would overwrite rather than version if re-run.

These are pre-existing, documented limitations of the authoritative file itself, not reasons to prefer the extracted-from-PDF file, which remains strictly worse (fewer rows, corrupted values) per the evidence above.

## Source

All figures and findings in this statement are drawn directly from `03_PRICING_MASTER_AUDIT.md` (repo root), audited 2026-08-09. Refer to that document for full methodology and the complete gap list.
