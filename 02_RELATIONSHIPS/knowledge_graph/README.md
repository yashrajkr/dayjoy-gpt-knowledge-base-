# Knowledge Graph

Built from existing canonical data (no invented facts or relationships). Contains:

- `kg_nodes.csv` — node_id, node_type, label, source_id. Node types: Product (170), Ingredient (217, deduplicated), Benefit (134, deduplicated), FAQ (1,897), Category (12), Policy (3), Company (1). Total: 2,434 nodes.
- `kg_edges.csv` — edge_id, source_node_id, target_node_id, relationship, evidence_source, verification_status. Total: 3,977 edges.

## Derivation sources

| Relationship | Source |
|---|---|
| Company -SELLS_PRODUCT-> Product | `01_CANONICAL/products/dayjoy_product_master_canonical.csv` |
| Company -HAS_CATEGORY-> Category | `01_CANONICAL/company/dayjoy_categories.csv` |
| Product -BELONGS_TO_CATEGORY-> Category | product master `category` column |
| Product -CONTAINS_INGREDIENT-> Ingredient | product master `ingredients` column |
| Product -HAS_BENEFIT-> Benefit | product master `benefits` column |
| Product -HAS_FAQ-> FAQ | `01_CANONICAL/faq/dayjoy_faq_canonical_v2.csv` (join: FAQ `product_code` == Product `product_id`) |
| Product -SIMILAR_TO-> Product | product master `similar_product_ids` + `dayjoy_product_relationships.csv` (`similar_product` rows) |
| Product -RELATED_TO-> Product | product master `related_product_ids` + `dayjoy_product_relationships.csv` (`budget_to_premium_variant` rows) |
| Product -RECOMMENDED_WITH-> Product | `dayjoy_product_relationships.csv` (`recommended_combination` rows only — sourced from the health condition recommendation chart) |
| Company -HAS_POLICY-> Policy | the 3 policy PDFs in `01_CANONICAL/policies/` |

## Verification status

`verification_status` on `HAS_FAQ` edges is inherited from the `verified` column in `dayjoy_faq_canonical_v2.csv` (itself derived from the original `confidence` field: `medium`/`high` -> verified, `low` -> unverified — `low` confidence rows are 100% placeholder/abstention answers, e.g. "Information not available in source documents"). All other edge types are `verified` because they are direct column values copied from approved canonical source files.

## Scope note

No entity resolution/synonym-merging was attempted for Ingredient or Benefit nodes beyond exact case-insensitive string match after basic tokenization (e.g. splitting a combined "Vitamin A, B12, C, E, K" ingredient string). This means near-duplicate phrasings (e.g. two products describing the same benefit with slightly different wording) may appear as separate nodes — that is a known limitation, not a fabrication.

`category_graph/` (parent-child category hierarchy) remains intentionally empty per its own README — building it would require deriving a hierarchy that doesn't exist in any source document.
