# Dayjoy Claim Verification Standard

## Purpose
Every factual claim the AI Brain can surface — a price, a health benefit, a dosage, a compensation figure, a "best-selling" label, an income statement — must carry a verification tier. This document defines the three tiers, maps them onto the fields that already exist in the repository, and states which fields are missing the tier they should have. It does not re-derive or regenerate any dataset; it labels what is already there and flags what isn't.

## The three tiers

### VERIFIED
The claim has been independently cross-checked against a named, dated, page-cited authoritative source, and the check is recorded (who/when/how). A verified claim can be answered directly.

Examples already in the repository:
- `01_CANONICAL/compensation/dayjoy_plan_ranks_rewards_VERIFIED.csv` — all 17 rows cross-checked field-by-field against OCR of the GrowthX deck, page-cited, dated 2026-08-09.
- `01_CANONICAL/pricing/*` — MRP/DP/BV sourced from "India BV Price May 2026.pdf", consistent across independent pipelines.

### UNVERIFIED
The claim has a named source document, but has not been independently cross-checked, or the row-level `verification_status` disagrees with a stricter field-level signal (see "Known inconsistency" below). Unverified claims may be answered **only with citation and a disclaimer** — never as flat fact.

Examples already in the repository:
- `01_CANONICAL/products/dayjoy_product_master_canonical.csv` — `benefits`, `dosage`, `ingredients`, `usage`, `contraindications` columns. Every row in this file currently has `content_risk_level = high`, meaning these fields were extracted from brochure/catalog text but not independently verified against a medical or regulatory source. Treat as UNVERIFIED regardless of what `verification_status` says (see inconsistency note).
- `01_CANONICAL/compensation/dayjoy_compensation_conflicts.csv` — 3 rows explicitly `CONFLICT_UNRESOLVED`. Neither the old value nor the PDF value may be stated as fact until a human picks one.

### INFERRED
The claim was derived by the pipeline from patterns in the corpus (mention frequency, co-occurrence, keyword joins) rather than read directly off a primary source that states the fact. Inferred claims must always be labeled as such in the answer and must never be phrased as a factual company statement.

Examples already in the repository:
- `07_ANALYTICS/metrics/dayjoy_best_selling_products.csv` — `insight_type = best_selling_proxy`, `basis` column literally says "Ranked by frequency of product mentions across unified corpus; proxy only, not actual sales." This is NOT real sales data. Dayjoy has never supplied actual sales/order volume.
- `07_ANALYTICS/metrics/dayjoy_income_opportunities.csv` — `insight_type = income_opportunity`, derived from chunk co-occurrence, not from an actual earnings statement or income disclosure.

## Known inconsistency — flagged, not silently fixed
In `dayjoy_product_master_canonical.csv`, `verification_status = approved` for all 170 rows, while `content_risk_level = high` for all 170 rows. These two signals contradict each other if read in isolation: "approved" sounds like a green light, "high risk" says the opposite. This was inherited from the merge pipeline and was not corrected here because doing so would mean altering canonical data rather than governing how it's read.

**Rule for the AI Brain: when both fields are present, `content_risk_level` wins for anything touching health, dosage, ingredients, or usage.** `verification_status = approved` on this file should be read as "approved for catalog inclusion," not "approved as a verified health claim."

## Required behavior at answer time
1. Look up the claim's source file and its verification tier using the mapping above.
2. VERIFIED → answer directly, cite source.
3. UNVERIFIED → answer only with citation + the standard disclaimer (see `ABSTAIN_AND_LABELING_POLICY.md`), or abstain if the safety class forbids it (see `08_GOVERNANCE/safety/dayjoy_product_safety_classes.csv`).
4. INFERRED → answer only with an explicit "based on internal analysis, not verified sales/company data" framing, or abstain if the user's phrasing implies they want a factual company claim.
5. No source found at all → abstain. Do not fill the gap with plausible-sounding text.

## Ownership
This standard should be reviewed any time a new dataset is added to `01_CANONICAL/`, `04_RAG/`, or `07_ANALYTICS/`. New files must be classified into one of the three tiers before they are wired into retrieval.
