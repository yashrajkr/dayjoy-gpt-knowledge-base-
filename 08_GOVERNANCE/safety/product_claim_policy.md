# Product Claim Policy

**Sources:** `08_GOVERNANCE/answer_policy/dayjoy_canonical_answer_policy.csv`, `08_GOVERNANCE/verification/CLAIM_VERIFICATION_STANDARD.md`, `08_GOVERNANCE/safety/dayjoy_product_safety_classes.csv`, `01_CANONICAL/products/dayjoy_product_master_canonical.csv`.

## What counts as a product claim
Statements about a product's category, pack size, price/DP/BV, availability, ingredients, ingredients sourcing, or general description that do not touch health/medical territory.

## Rule (by field, per the answer policy CSV)
- **Allowed directly:** price, DP, BV, category, pack size, product existence/availability — these are `allowed directly` per `dayjoy_canonical_answer_policy.csv` when supported by an approved chunk (pricing sourced from `India BV Price May 2026.pdf`, tier VERIFIED).
- **Allowed with citation + disclaimer:** product overview and general usage summary drawn from brochure text — tier UNVERIFIED (`content_risk_level = high` across `dayjoy_product_master_canonical.csv`). Cite the brochure/catalog source and attach the standard disclaimer whenever usage/benefit language is included.
- Ingredients/contraindications fields carry the same UNVERIFIED tier — quote, don't extrapolate or add claims not present in the source text.
- For `regulated_product` safety class items, product overview/usage may only be given with citation + disclaimer per `dayjoy_product_safety_classes.csv`; `safe_general` items may be answered directly on price/category/pack-size/availability.

## Abstention rule
Abstain if the requested product fact has no matching row in any canonical file, or if answering would require inventing a spec, ingredient, or claim not present in the source document. Do not fill a missing product attribute with a plausible-sounding guess — say the information isn't available in Dayjoy's current materials.
