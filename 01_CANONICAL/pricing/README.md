# Pricing Folder — File Status

This folder contains multiple representations of Dayjoy pricing data. Not all files are safe to use. Read this before using anything here.

## Authoritative — use this

- **`dayjoy_price_list_may2026.csv`** (170 rows) — the current, authoritative pricing file. Verified against `dayjoy_product_master_canonical.csv` (see `03_PRICING_MASTER_AUDIT.md` at the repo root): `mrp`/`dp` agree on all 170 products with **zero mismatches**, and `bv` agrees on all rows where both files had a value. As of 2026-08-09, `sku`, `product_id`, `pv`, and the 19 previously-missing `bv` values have been backfilled into this file from the verified product master join (see `03_PRICING_MASTER_AUDIT.md` Section 4 and 7 for the join methodology and evidence).
- **`dayjoy_price_list_may2026.json`** and **`dayjoy_price_list_may2026_supabase.sql`** — derived from, and kept consistent with, the CSV above. Same 170 products, same backfilled `sku`/`product_id`/`pv`/`bv` values as of 2026-08-09.

## Superseded — do NOT use

- **`dayjoy_price_list_extracted_from_pdf.csv`** (138 rows) — a **superseded, defective draft extraction**. It is NOT a genuinely different pricing source; it is an earlier, corrupted PDF-table-extraction pass over the same source PDF. Verified row-merging errors include:
  - Rows where a product's price/BV fields and the *next* product's category header and name got concatenated into one cell (e.g. `sno=63`, `sno=65`), with the corresponding next `sno` row missing entirely.
  - A run of ~10 product names, prices, and row numbers merged into a single field near `sno=157`–`164`.
  - Some rows carry **another product's price data under the wrong product name** (e.g. the stored row for AcneX actually contains Amara Beauty Kajal's true mrp/dp/bv values).

  Full evidence is documented in `03_PRICING_MASTER_AUDIT.md` (repo root), Section 3. This file must not be used for pricing, joins, imports, or any downstream calculation. It has not been deleted or modified — it is retained for forensic/reference purposes only.

  A copy of this file, plus pre-backfill copies of the three authoritative files above, is archived at `99_ARCHIVE/superseded/` with a `_PRE_FIX_2026-08-09` suffix, preserving the state of all pricing files as they existed before the 2026-08-09 sku/product_id/pv/bv backfill.

## Reference

- Source PDF: `India BV Price May 2026.pdf` (in this folder).
- Full audit and evidence trail: `03_PRICING_MASTER_AUDIT.md` at the repo root.
