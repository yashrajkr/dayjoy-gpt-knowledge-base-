# T002B — Image & Catalog-Identity Rematch Pass (2026-08-10)

Follow-up to the original T002 image integration pass (source: `06_IMAGES/metadata/dayjoy_image_placement_manifest.csv`, `products_without_images.csv`). This pass re-examined the full source image archive and the two other known gaps with fresh eyes, per the standing rule: **no image is placed without genuine, verifiable confidence.**

## 1. Source archive reconciliation (fresh unzip)

`Dayjoy All Product Images.zip` was re-extracted to a scratch temp directory (original zip untouched) and diffed file-for-file against `dayjoy_image_placement_manifest.csv`.

- Zip contains **128 files**, exactly matching the manifest's 128 `zip_path` rows.
- Set difference both ways is empty — **zero orphan/unused images** exist outside what the prior pass already tracked.
- Of the 128: **120 were already placed** (covering 108 unique SKUs, several SKUs having multiple alt images `_1`/`_2`/`_3`) and **8 were declined** with reasons recorded (`manual_review`, `placed=False`).

Conclusion: there was no pool of "forgotten" images to mine — the only re-examination opportunity was the 8 previously-declined files. This pass did not fabricate a larger opportunity than actually exists.

## 2. Coverage result

| | Before | After |
|---|---|---|
| SKUs with an image | 108/170 | **109/170** |
| SKUs with no image | 62/170 | **61/170** |

**One new match applied.**

## 3. The 8 previously-declined images — re-examined against the FULL 170-product list, with visual inspection

| Filename | Prior reason declined | Re-check result |
|---|---|---|
| `Joy_1.jpg` | "too generic filename" | **MATCHED** — see below |
| `Agni Combo.jpeg` | no matching canonical combo SKU | still unmatched — confirmed |
| `Diva Basic.jpeg` | no matching canonical combo SKU | still unmatched — confirmed |
| `Diva Super.jpeg` | no matching canonical combo SKU | still unmatched — confirmed |
| `Suit lenght Combo.jpeg` | no matching canonical combo SKU | still unmatched — confirmed |
| `Tez combo.jpeg` | no matching canonical combo SKU | still unmatched — confirmed |
| `Udaan.jpeg` | no matching canonical combo SKU | still unmatched — confirmed |
| `Magentic Braslet.png` | no SKU exists | still unmatched — confirmed |

### 3a. NEW MATCH: `Joy_1.jpg` → **DJ-AGR-0135 "JoyProtect (500ml)"**

The filename alone (`Joy_1.jpg`) genuinely is generic and gave no clue — that part of the original call was reasonable. But opening the image shows a product bottle with a clearly legible label: **"HAPPYGROW — JOYPROTECT (Botanical Extract) Plant Protector — NET QUANTITY: 500 ml"**.

Cross-checked against the 170-product master: `DJ-AGR-0135`, product_name = "JoyProtect (500ml)", brand = "HappyGrow", category = AGRICULTURE & VETERINARY, and it was one of the 62 SKUs with **no image at all**. It is also the *only* product in the entire master with "Protect" in the name, so there is no ambiguity. Further corroboration: the 86-item source catalog (`dayjoy_products_catalog_UNRECONCILED_86items.csv`) independently lists "JoyProtect / HappyGrow / 500ml Bottle / ₹1499", and the canonical master's MRP for DJ-AGR-0135 is exactly 1499 — brand, product name, pack size, and price all agree.

**Confidence: very high (~0.98).** Applied.

Action taken:
- Image copied to `06_IMAGES/products/DJ-AGR-0135.jpg`.
- Row added to `06_IMAGES/metadata/dayjoy_image_metadata_CANONICAL.csv` and `dayjoy_image_metadata_FULL_SCHEMA.csv`.
- `image_ids` for DJ-AGR-0135 in `01_CANONICAL/products/dayjoy_product_master_canonical.csv` updated from empty to `DJ-AGR-0135.jpg`.
- `06_IMAGES/metadata/products_without_images.csv` updated (DJ-AGR-0135 removed, 62→61 rows).
- `06_IMAGES/metadata/dayjoy_image_placement_manifest.csv` row for `Joy_1.jpg` updated to `placed=True`.
- Pre-edit versions of all touched files archived to `99_ARCHIVE/superseded/*_PRE_FIX2_2026-08-10.csv` (image metadata CSVs, product master, placement manifest, catalog86-unmatched, products-without-images) before any in-place edit. Note: the product master already had an unrelated `_PRE_FIX_2026-08-09` archive from an earlier data-quality pass; this pass's archive uses a distinct `_PRE_FIX2` suffix so neither overwrote the other.

### 3b. The 6 combo-kit images — reconfirmed genuinely unmatched, not fabricated

Visually opened all six: `Agni Combo.jpeg`, `Diva Basic.jpeg`, `Diva Super.jpeg`, `Tez combo.jpeg`, `Udaan.jpeg`, `Suit lenght Combo.jpeg`. Every one is a full marketing poster for a **distributor "ID-activation" loyalty-program bundle** (headline name — AGNI "Ignite your Success", DIVA BASIC COMBO, DIVA SUPER COMBO, TEZ "Boost your Business", UDAAN "Key to Success", PREMIUM SUIT LENGTH), each listing 8–20 individual products plus Total MRP / Combo Price / FBV&RBV / referral income and loyalty-program terms.

These marketing names (Agni, Diva, Tez, Udaan) do not appear anywhere in the 170-product master, the 86-item source catalog, or any relationships file — searched exhaustively. They are a different business concept from the 6 canonical `COMBO PACKAGES` SKUs (STANDARD/PREMIUM/ELITE/AGRI PRO/AGRI STARTER/LEGEND PACKAGE), which use generic tier names, not these marketing names, and whose composition/pricing don't line up with any of these six posters either. Even the individual products pictured inside the bundles (HB+, Liv-Ease, Orthofix, Adilipo, Hi-Energy, Adila Forte, Adicardial Syrup, Asthprash, Gas-O-Free — several of which *are* on the 61-SKU no-image list) are shown only as small group-shot thumbnails inside a multi-product poster, not as usable standalone product photos — so they cannot honestly be extracted to cover those individual SKUs either.

One additional check performed this pass: `Suit lenght Combo.jpeg` markets "PREMIUM SUIT LENGTH" (MRP 7500, gift-boxed). This overlaps by name with `DJ-CLO-0120 "Premium Suit Length (Black)"`, but DJ-CLO-0120 already has its own dedicated image (`Premiumsuitlengthblack.webp`, placed in the original T002 pass) — so even if this were accepted as the same underlying product, it closes no gap, and it's a distributor gift-box shot rather than the standalone retail item, so it wasn't substituted in.

**No fabrication applied. Correctly remains declined.**

### 3c. `Magentic Braslet.png` — reconfirmed genuinely unmatched, no SKU exists

Visual: a gold-tone stainless-link bracelet with visible magnet inserts in several links. Searched the full 170-product master and the 86-item catalog for "bracelet," "magnetic," and "germanium." Result: only two products exist in the GERMANIUM & MAGNETIC category — `DJ-GER-0137` and `DJ-GER-0138`, both "Bio-Germanium & Magnetic Mattress" variants. There is no bracelet SKU anywhere in this knowledge base to attach the image to.

**No SKU exists for this product, full stop. Correctly remains declined — not a matching failure, a genuine catalog gap (there is no product to point the image at).**

## 4. Catalog item: "Neem & Aloevera Herbal Soap" (86-item catalog, unmatched)

Re-ran a full search of the 170-product master for soap/aloe/neem terms. Result is the same single candidate as before: `DJ-PER-0041 "Neem & Tulsi Herbal Soap (100g) (Pack of 3)"` (Wild Muse, PERSONAL CARE), name-similarity score 0.916.

**Still not auto-merged** — the source catalog explicitly lists this item's ingredients as "Neem, Aloe Vera," while DJ-PER-0041 is labeled Neem+Tulsi. That is a real formulation conflict, not a typo we can wave away.

New evidence found this pass that a human should weigh: DJ-PER-0041's price (MRP 147), pack format (Pack of 3, 100g each), and brand (Wild Muse) all match the catalog86 source entry for "Neem & Aloevera Herbal Soap" *exactly* — only the ingredient name differs. This raises real suspicion that these are the same physical SKU described inconsistently across two source documents (possible reformulation, or a data-entry error in one document), rather than two genuinely different products.

**Documented for human decision, not applied automatically.** Elevated candidate confidence: ~0.6 that it's the same SKU under an ingredient-name discrepancy (up from a bare 0.916 name-similarity score that was previously judged untrustworthy on its own). Recorded in `01_CANONICAL/products/dayjoy_products_catalog_86items_UNMATCHED.csv` and `06_REMAINING_GAPS.csv` (G027). A human at Dayjoy needs to confirm the actual ingredient list before this can be merged.

## 5. Honest remaining-gap list — 61 SKUs with genuinely no source photo

No source photo exists anywhere in the 128-image archive for any of these. This is the full, current list (from `06_IMAGES/metadata/products_without_images.csv`):

**FOOD PRODUCTS (12):** DJ-FOO-0005 Daily Tea (500g); DJ-FOO-0006 Dhaniya Powder (25g); DJ-FOO-0007 Dhaniya Powder (200g); DJ-FOO-0010 Haldi Powder (25g); DJ-FOO-0011 Haldi Powder (200g); DJ-FOO-0013 Himalayan Pink Salt Sprinkler (200g); DJ-FOO-0015 Organic Jeera (250g); DJ-FOO-0017 Mirchi Powder (25g); DJ-FOO-0020 Rai (250g); DJ-FOO-0021 Sabji Masala (100g); DJ-FOO-0022 New Total Joy Rice Bran Oil (1 Litre); DJ-FOO-0024 Veg Biryani with Shahi Gravy; DJ-FOO-0026 Upma with Bhujia.

**PERSONAL CARE / SKIN CARE (6):** DJ-PER-0027 Anti Pollution Face Wash (150ml); DJ-PER-0039 Milk Bath Soap (100g); DJ-PER-0043 Sandalwood & Shahi Gulab Body Lotion (150ml); DJ-PER-0044 Sanitary Pad (XL) (Pack of 10); DJ-PER-0053 Deep Cleansing Face Wash (100ml); DJ-SKI-0059 Gold Facial Kit.

**HEALTH CARE (8):** DJ-HEA-0068 Adicardial Syrup (500ml); DJ-HEA-0069 Adila Forte (30 Tab); DJ-HEA-0071 Adilipo (120 Tab); DJ-HEA-0082 Gas-O-Free (200ml); DJ-HEA-0084 GoPiles (60 Tab); DJ-HEA-0093 Liv-Ease (200ml); DJ-HEA-0097 N-astheal (120 Tab); DJ-HEA-0099 Orthofix (60 Tab). *(Note: several of these appear only as small thumbnails inside the declined multi-product combo posters — see §3b — not usable as standalone product photos.)*

**CLOTHING (1):** DJ-CLO-0123 T-shirt New Design (L, M, XL).

**AGRICULTURE & VETERINARY (4):** DJ-AGR-0127 Nano Tech-50 (500ml); DJ-AGR-0128 Nano Tech-52 (500ml); DJ-AGR-0130 Prosperous+ Tablets; DJ-AGR-0132 JoySpread 80+ Gold (250ml).

**GERMANIUM & MAGNETIC (1):** DJ-GER-0137 Bio-Germanium & Magnetic Mattress.

**AQUA ESSENTIALS (6):** DJ-AQU-0139 Aqua Energiser (Pack of 3); DJ-AQU-0142 Perfect-Ion Testing Solutions; DJ-AQU-0143 Perfect-Ion Leaflets (Set of 25); DJ-AQU-0144 Perfect-Ion Leaflets (Set of 50); DJ-AQU-0145 N-SF 9.5 Mineraliser; DJ-AQU-0146 N-SF 10.5 Mineraliser.

**PROMOTION TOOLS (18):** DJ-PRO-0147 through DJ-PRO-0164 — Dayjoy Diary, Leather Bag, Cap, Mug, Bike Sticker, Car Sticker, Pin, Backpack Bag, Product Brochures (Hindi/English/Telugu), Product Leaflets, One-Page Compensation Plan leaflets (Hindi/English, sets of 25/50), Business Planner Books (Hindi/English).

**COMBO PACKAGES (4):** DJ-COM-0166 PREMIUM PACKAGE; DJ-COM-0167 ELITE PACKAGE; DJ-COM-0168 AGRI PRO PACKAGE; DJ-COM-0170 LEGEND PACKAGE. *(These are the canonical tier-named combo SKUs; the marketing-named bundle posters in §3b photograph a different, unlinked concept and cannot substitute.)*

**Bracelet/magnetic-jewelry gap:** no SKU exists for the magnetic bracelet image at all (§3c) — this is a catalog gap, not counted in the 61 since there is no SKU row to attach it to either way.

This list is expected to require new source photography/material from Dayjoy — it is not a processing gap that further data engineering can close.
