# Embeddings Manifest — intentionally empty

No embeddings have been generated for this repository, and none should be until the gate below clears. This mirrors the original project rule: **never generate embeddings until canonical data is finalized.** Generating embeddings now would mean re-embedding again the moment any of the open items below resolve — wasted compute and, worse, a window where retrieval is running against stale vectors.

## Gate — do not generate embeddings until:
- [ ] The 3 compensation conflicts in `01_CANONICAL/compensation/dayjoy_compensation_conflicts.csv` are resolved (retail profit %, mentorship bonus %, business matching structure).
- [ ] `01_CANONICAL/products/dayjoy_products_catalog_86items_UNMATCHED.csv` (1 item, "Neem & Aloevera Herbal Soap") is resolved or formally accepted as out of scope.
- [ ] Any newly-added website-sourced facts (see `00_SOURCE_DOCUMENTS/website_snapshots/`) have been registered and cross-checked, not left as raw scrape.

Full detail: `PRODUCTION_READINESS_REPORT.md` at the repository root.

## When ready
This folder should hold, per chunk source file: `embedding_model`, `embedding_model_version`, `chunk_id` → `vector_id` mapping, generation timestamp, and a content hash of the chunk at embedding time (so a later content change is detectable and triggers re-embedding of only the changed chunks, not the whole corpus). Use `04_RAG/chunks/dayjoy_rag_chunks_CANONICAL.csv` as the input once the gate clears.
