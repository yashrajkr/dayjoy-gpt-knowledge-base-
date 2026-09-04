# DAYJOY DATA UPDATE — July 2026 Brochure Integration

This package contains the FULL set of previously existing Dayjoy knowledge-base files,
UPDATED with new information extracted from the attached
"Dayjoy-Product-Brochure-English-July2026_11zon.pdf".

## What was updated
- dayjoy_products_price_list_may_2026.csv: 62 of 170 existing products enriched
  with ingredients, benefits, usage instructions, and category from the July 2026 brochure (matched by name).
- dayjoy_company_overview.csv: added/confirmed R&D leadership, manufacturing scale, and group companies info.
- dayjoy_NEW_products_from_July2026_brochure.csv: 28 products found in the brochure
  that were NOT present in the prior price list (e.g. AdilaForte Tablet, Hi-Energy Tablet, HB+ Syrup, Ample Meal,
  JuniorJoy, Premium Sanitary Pads, JoyCalcium, and more) — recommended for addition to master catalog.
- Dayjoy_Products_Catalog.csv (NEW): full 86-product catalog freshly extracted from the July 2026 brochure with
  ingredients, benefits, usage, pack size, and MRP for every product/sub-brand.
- Dayjoy_Company_Profile.csv (NEW): consolidated company profile from the brochure.
- Dayjoy_Health_Recommendation_Chart.csv (NEW): condition-to-product recommendation mapping (Diabetes, Heart,
  Liver, Bone & Joint, Weight Management, Skin, Female/Male health, General wellness) directly from brochure pages 71-75.

## Unchanged files (carried over as-is)
- dayjoy_knowledge_base.json
- dayjoy_faq.csv
- dayjoy_compensation_plan.csv
- dayjoy_products.csv (legacy master; see price_list file for enriched version)
- dayjoy_sub_brands.csv
- dayjoy_gpt_knowledge_base.txt
- dayjoy_gpt_implementation_plan.txt
- dayjoy_products_price_list_may_2026.json
- dayjoy_supabase_products_may_2026.sql
- dayjoy_gpt_knowledge_base_price_update_may_2026.md
- dayjoy_rag_chunks_price_may_2026.json
- DAYJOY_UPDATED_PACKAGE_README.md (previous version's readme, retained for history)

## Source
Dayjoy-Product-Brochure-English-July2026_11zon.pdf (user-uploaded, July 2026 edition)
