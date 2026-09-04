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
