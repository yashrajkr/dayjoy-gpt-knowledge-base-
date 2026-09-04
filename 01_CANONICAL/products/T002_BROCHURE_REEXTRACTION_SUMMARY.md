# T002 — Brochure Re-Extraction Summary (Warnings / Contraindications / Certifications / Dosage)

**Date:** 2026-08-09/10
**Source re-processed:** `00_SOURCE_DOCUMENTS/brochures/Dayjoy Product Brochure - English July2026_11zon.pdf` (78 pages)
**Method:** The brochure is a fully **image-based/scanned PDF** — `pdftotext -layout` returned zero extractable text (form-feed characters only) on the first attempt. This pass instead rendered all 78 pages to PNG (`pdftoppm -r 200`), ran full-page OCR (`tesseract --psm 6`) on every page (including 8 pages — 39–46 — that silently failed in the first OCR batch run and were re-OCR'd individually), and re-ran a higher-resolution (400dpi) OCR pass on page 29 to confirm one garbled reading. The full 78-page OCR text (~3,500 lines) was then searched systematically for warning/certification/dosage language and cross-matched against the 170 canonical product names.
**Archive:** Pre-change CSV copied to `99_ARCHIVE/superseded/dayjoy_product_master_canonical_PRE_FIX2_2026-08-09.csv` before any edits (verified byte-identical via md5 before the update).

## Headline finding: the brochure genuinely has almost no per-product safety content

A full-text search for `caution`, `warning`, `contraindicat*`, `side effect*`, `hypersensit*`, `should not`, `not suitable`, `not advisable`, `keep out of reach`, `overdose`, `not to be taken`, `external use only`, `discontinue use`, `not exceed`, `physician before`, `doctor before`, `pregnan*`, `lactating` was run across the entire 78-page OCR text. Across ~140 consumable/wellness/cosmetic product listings, this turned up genuine per-product safety language for **exactly two products**:

1. **Arogya Churn (100g)** (`DJP1078`, Curind) — p.24: *"Do not exceed the recommended dose. Pregnant and lactating women should consult their physician before using."* — **this was already present** in the master (the pre-existing 1-of-170 warnings row); confirmed as an accurate match, no change needed.
2. **JuniorJoy – Kids Nutritional Drink (300g)** (`DJP1110`, Curind) — p.29: *"...2 servings per day. Not recommended for children under the age of 5 years."* (verified by re-OCR at 400dpi, since the first pass rendered this line as garbage). The dosage field already captured this obliquely; the dedicated **contraindications** field was empty — **now filled**.

No other product page in the brochure contains caution/contraindication/side-effect language. This is a genuine content gap in the *source document*, not a missed extraction — most Dayjoy brochure pages are pure benefits/ingredients/price marketing copy with no regulatory-style safety text.

## Certifications — one per-product claim, one facility-wide statement (not applied per-row)

- **Bio-Germanium & Magnetic Mattress** (`DJP1136`/`DJP1137`) — p.59: *"It's also one of its kind Mattress that is approved by Ministry of Health & Family Welfare, Government of India as a MEDICAL GRADE DEVICE."* This is a genuine per-product regulatory claim. It was **already present** in the master (`certifications = "MEDICAL GRADE DEVICE"`) from a prior pass — not overwritten (constraint: never clobber existing content), though the fuller citation (issuing body) is documented here for the record.
- **p.5 facility statement**: *"Every product is crafted in a hygienic environment using premium raw materials and meets top certifications like ISO, GMP, WHO-GMP, FSSAI, FDA, HALAL, and HACCP"* (scoped explicitly to the FMCG/Ayurvedic/food-supplement/cosmetic manufacturing lines). **Deliberately not applied** to the ~155 empty `certifications` cells. Reason: this is a facility-level manufacturing claim, not a per-SKU certificate/license number, and stamping it onto every row (including agri inputs, apparel, merchandise, and business collateral that fall outside the stated scope) would overstate precision and risk exactly the "forced generic content" this task was designed to avoid. Recorded here as available context instead.
- **p.70 "Certificates and Recognitions" page**: lists company/business registrations (GMP Appreciation certificate, ISO 9001:2015, Food & Drugs Administration registration, Ayush Ministry Licence, FICCI Licence, state direct-selling registrations, Startup India). These are **company-level**, not product-level, and were not applied to any row.

**Bottom line on certifications:** the brochure supports exactly 1 genuine per-product certification claim, already captured pre-existing. No new certification cells were filled this pass. 163/170 products (95.9%) have no certification content, and honestly, the brochure does not provide it at product level.

## Dosage/usage — 14 products gained genuine new content

Beyond warnings/certifications, the brief also asked to capture "any dosage/usage detail not yet captured." The Curind wellness line (50 products) was already ~100% filled for ingredients/benefits/dosage from a prior pass. Re-reading the OCR text found additional literal usage steps for two areas the prior pass had missed or only partially captured:

- **Wild Muse Seabuckthorn Facial Kit** (p.40–41): the kit's combined "HOW TO USE?" routine gives an explicit 6-step sequence, one step per individual product in the kit. Each step was matched to its own SKU and filled into that SKU's (previously empty) `dosage` field: `DJP1046` Cleanser, `DJP1047` Scrub, `DJP1048` Massage Gel, `DJP1049` Massage Cream, `DJP1050` Face Pack, `DJP1051` Facial Fluid.
- **Amara Beauty** (p.43–45): explicit "HOW TO USE?" instructions existed in the brochure but had only been captured into the `usage` field previously, leaving `dosage` empty: `DJP1058` Gold Facial Kit, `DJP1061` AgeX Night Cream, `DJP1062` AcneX Cleanser, `DJP1063` Kajal, `DJP1064` Eyeliner.
- **HappyGrow agri inputs**: `DJP1128` Prosperous+ (1L) and `DJP1131` JoySpread 80+ Gold (250ml) — the brochure gives one combined dosage instruction covering both pack-size variants of each product; the smaller/larger sibling SKU already had it captured, the other pack size did not. Filled from the same literal brochure passage (p.56–57).
- `DJP1138` Aqua Energiser (Pack of 3) — filled `ingredients` and `dosage` by mirroring the literal p.59 description already correctly captured on the sibling single-unit SKU (`DJP1139`), since both variants share one product description block in the brochure.

## Confirmed genuine absences (checked, not found — not fabricated)

These products/lines were specifically searched for in the OCR text and are **not present in this brochure edition** at all, so their remaining NULL fields are a real source-document gap, not a missed extraction: Sandalwood & Shahi Gulab Body Lotion (`DJP1042`), Designer Mask (`DJP1120`), Nano Tech-19/46/50/52 (`DJP1124`–`DJP1127`), Perfect-Ion products (`DJP1140`–`DJP1143`), N-SF 9.5/10.5 Mineraliser (`DJP1144`–`DJP1145`), and several Wild Muse/HomeShine items where only a benefits bullet list exists with no ingredient list or dosage instructions anywhere on the page (e.g. BR Rich Oil, Daily Care Cream, Luxwash Handwash, Kesham, HomeShine cleaning products).

## Net change this pass

| Field | Before | After | New fills |
|---|---|---|---|
| warnings | 1 (0.6%) | 1 (0.6%) | 0 (only existing match confirmed) |
| contraindications | 1 (0.6%) | 2 (1.2%) | 1 (JuniorJoy) |
| certifications | 7 (4.1%) | 7 (4.1%) | 0 (existing Bio-Germanium claim confirmed, not duplicated; blanket facility statement deliberately not applied per-row) |
| dosage | 98 (57.6%) | 112 (65.9%) | 14 |
| ingredients | 92 (54.1%) | 93 (54.7%) | 1 |
| benefits | 133 (78.2%) | 133 (78.2%) | 0 |

**Total cells changed: 16, across 15 products.** All edits fill previously-NULL cells only; no existing content was overwritten; `mrp`/`dp`/`bv`/`pv`/`sku`/`product_id` were never touched (verified by diffing every field of every row against the archived pre-change copy).

## Honest statement of the remaining gap

After this thorough re-extraction, **warnings and contraindications remain essentially absent from this data source** — 168/170 products (98.8%) have no warnings text and 168/170 (98.8%) have no contraindications text, because the brochure itself is a sales/marketing document, not a regulatory label, and only contains safety language for 2 of ~140 consumable SKUs. Certifications remain absent for 163/170 products (95.9%) for the same reason — the brochure documents facility-level and company-level certifications, not per-SKU ones (except the one mattress medical-device claim). If per-product warnings/contraindications/certifications are required for compliance purposes, they will need to come from product packaging, FSSAI/regulatory filings, or manufacturer data sheets — this brochure does not contain them, and no generic or invented safety text was added to compensate.
