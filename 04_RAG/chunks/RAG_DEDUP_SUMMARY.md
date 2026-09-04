# RAG Chunk Deduplication Summary

Run 2026-08-09/10. Follows up on the "77 distinct duplicate-text groups covering 1,437 of 2,242 chunks (1,360 redundant rows)" finding in `CROSS_DATA_VALIDATION_REPORT.md`. This pass actually performs the dedup that report flagged as a "targeted follow-up, not done in this pass."

## What was done

1. The pre-dedup canonical chunks file was archived unmodified to
   `99_ARCHIVE/superseded/dayjoy_rag_chunks_CANONICAL_PRE_DEDUP_2026-08-09.csv`.
2. `04_RAG/chunks/dayjoy_rag_chunks_CANONICAL.csv` was rewritten in place with exact-duplicate
   `text` groups collapsed to one representative row each.
3. `04_RAG/metadata/dayjoy_metadata_registry_ENRICHED.csv` and
   `04_RAG/metadata/dayjoy_metadata_registry_canonical.csv` were filtered to the same surviving
   `chunk_id` set (both are keyed 1:1 to the chunks file).

## Row counts

| File | Before | After | Rows removed |
|---|---:|---:|---:|
| `dayjoy_rag_chunks_CANONICAL.csv` | 2,242 | 882 | 1,360 |
| `dayjoy_metadata_registry_ENRICHED.csv` | 2,242 | 882 | 1,360 |
| `dayjoy_metadata_registry_canonical.csv` | 2,242 | 882 | 1,360 |

- Distinct duplicate-text groups found: **77** (matches the cross-validation report exactly).
- Total rows across those 77 groups: **1,437**.
- Rows kept as group representatives: **77**.
- Rows dropped as redundant: **1,437 − 77 = 1,360**.
- All 1,360 dropped rows are `chunk_type == faq_pair` — confirming the report's description that
  the duplication is almost entirely templated "Information not available in source documents"
  FAQ placeholders repeated per product (e.g. the shelf-life placeholder text alone appeared 170
  times across different products, all with byte-identical answer text).

## Selection rule

For each duplicate-text group, one representative row was kept:
1. Prefer the row with the most complete metadata — count of non-empty `product_code`, `sku`,
   `category` fields (highest wins).
2. Tie-break: lowest `chunk_id` (lexicographic), for determinism.
3. All other rows in the group were dropped. Only genuinely exact-duplicate `text` values were
   collapsed — no row was dropped for being merely similar to another; the entire file was grouped
   on the literal `text` column value with no fuzzy matching.

## Content-loss check

Every dropped row's `text` was compared byte-for-byte against its group's kept representative row
(both pulled from the pre-dedup archive). Result: **0 rows** where the dropped content differs from
the kept content, and every dropped row's exact text string is still present in the post-dedup
`text` column. No information was lost — only redundant repetition was removed.

## Re-verification after dedup

- **Orphan SKU check** (chunk `sku` values not present in
  `01_CANONICAL/products/dayjoy_product_master_canonical.csv`): **0 orphans** out of 170 distinct
  SKUs referenced in the deduplicated chunks file — same clean result the cross-validation report
  found pre-dedup, confirmed to still hold post-dedup.
- All three files (`dayjoy_rag_chunks_CANONICAL.csv`, `dayjoy_metadata_registry_ENRICHED.csv`,
  `dayjoy_metadata_registry_canonical.csv`) now contain identical `chunk_id` sets (882 each), so no
  new referential mismatch was introduced by the dedup.
