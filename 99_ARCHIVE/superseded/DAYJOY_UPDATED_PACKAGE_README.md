# DayJoy Updated Data Package

## Confirmed input source
**Used and analyzed:** `India-BV-Price-May-2026.pdf`, uploaded in this chat as `file:37`.

It is a four-page DayJoy price list, stating prices effective **5 May 2026** and inclusive of tax. It contains **170 product/package/tool records**.

## Updated outputs
- `dayjoy_products_price_list_may_2026.csv`: import-ready product pricing rows
- `dayjoy_products_price_list_may_2026.json`: structured product catalog data
- `dayjoy_supabase_products_may_2026.sql`: Supabase PostgreSQL table and safe upsert statements
- `dayjoy_gpt_knowledge_base_price_update_may_2026.md`: upload to GPT / RAG knowledge
- `dayjoy_rag_chunks_price_may_2026.json`: one retrieval chunk per product

## Important limitations
The uploaded price-list PDF does not provide ingredient panels, product benefits, usage, dosage, warnings, certifications, SKU, PV, images, policies, training details, or full compensation-plan rules. Those fields are deliberately `null` / marked unavailable rather than invented.

## Supabase process
1. Open Supabase Dashboard → SQL Editor.
2. Run `dayjoy_supabase_products_may_2026.sql`.
3. Upload the CSV or JSON as a validation/import alternative.
4. In your RAG pipeline, embed `dayjoy_rag_chunks_price_may_2026.json` and preserve metadata filters on `effective_date`, `source_file`, and `category`.


## UPDATE LOG - All Files Synced with Full 170-Product Price List

Every file in this package has now been cross-checked and updated with the COMPLETE 170-item
dataset extracted from India-BV-Price-May-2026.pdf (previously only 50 items were reflected in
dayjoy_products.csv and the GPT knowledge base text).

### Files updated in this pass:
1. dayjoy_products.csv - REPLACED: now contains all 170 products (was 50)
2. dayjoy_knowledge_base.json - product_catalog rebuilt with all 170 items across 12 categories;
   added product_catalog_meta, 6 new sub-brands, and combo_packages section
3. dayjoy_sub_brands.csv - added 6 newly discovered sub-brands (Seabuckthron, Amara Beauty,
   Joy Series, Perfect-Ion, Aqua Energiser, Bio-Germanium)
4. dayjoy_company_overview.csv - added verified product/category counts and price list source
5. dayjoy_compensation_plan.csv - appended verified combo/joining package pricing table
6. dayjoy_gpt_knowledge_base.txt - product catalog section fully replaced with all 170 priced
   items grouped by category; sub-brands list expanded to 14
7. dayjoy_faq.csv + JSON faq array - added 10 new FAQs specific to verified pricing/packages

### Consistency check
- Total products across all files: 170 (Food 26, Personal Care 31, Skin Care 6, Color Cosmetics 2,
  Health Care 50, Home Care 4, Clothing 4, Agriculture & Veterinary 13, Germanium Magnetic 2,
  Aqua Essentials 8, Promotion Tools 18, Combo Packages 6 = 170)
- Single source of truth: India-BV-Price-May-2026.pdf, effective 5 May 2026
- Fields still missing (by design, not invented): PV, ingredients, dosage, warnings,
  certifications, SKU, product images, detailed benefits/usage text
