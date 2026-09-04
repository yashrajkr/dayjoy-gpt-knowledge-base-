# Dayjoy Abstain and Labeling Policy

This extends `dayjoy_canonical_answer_policy.csv` and `dayjoy_source_verification_sop.md` with explicit, mandatory rules for five claim categories the AI must never invent. This policy is binding at the answer-generation layer, not just at ingestion.

## The five mandatory-label-or-abstain categories

### 1. Health benefits
Source: `01_CANONICAL/products/*.benefits`, `*.usage`, `*.contraindications`.
Tier: UNVERIFIED (see `CLAIM_VERIFICATION_STANDARD.md`).
Rule: may be summarized **only** with citation to the source brochure/catalog and the disclaimer below. Never state a benefit as medically proven. Never answer a diagnosis, cure, or "will this fix my X" question — escalate per `dayjoy_canonical_answer_policy.csv` ("not allowed without escalation").

### 2. Dosage
Source: `01_CANONICAL/products/*.dosage`.
Tier: UNVERIFIED.
Rule: may be quoted verbatim from the source document with citation. Never adjusted, extrapolated, or given for a use-case the source doesn't cover (e.g. never infer a child's dose from an adult dose).

### 3. Compensation / income-mechanics claims
Source: `01_CANONICAL/compensation/*`.
Tier: VERIFIED for the 17 rank rows in `dayjoy_plan_ranks_rewards_VERIFIED.csv`; UNVERIFIED/CONFLICT_UNRESOLVED for the 3 rows in `dayjoy_compensation_conflicts.csv` (retail profit %, mentorship bonus %, business matching structure).
Rule: for the 3 conflicting fields, **do not state either the old value or the PDF value as fact.** Abstain and route to human/distributor-support escalation until a human resolves the conflict (tracked in `PRODUCTION_READINESS_REPORT.md`, "CONFLICTING" section).

### 4. "Best-selling" / popularity claims
Source: `07_ANALYTICS/metrics/dayjoy_best_selling_products.csv`.
Tier: INFERRED. This file is a mention-frequency proxy across the internal text corpus. **Dayjoy has not supplied real sales or order data.**
Rule: never say "our best-selling product is X." If asked, respond with the proxy framing only, e.g. "Based on how often it comes up in our internal materials, X and Y are mentioned most — this isn't a confirmed sales ranking." If the user clearly wants an actual sales ranking, abstain and say real sales figures aren't available.

### 5. Business / income claims
Source: `07_ANALYTICS/metrics/dayjoy_income_opportunities.csv`, and any compensation-plan earning example.
Tier: INFERRED (analytics file) or VERIFIED-but-illustrative (the PDF's worked examples, which are hypothetical scenarios, not guarantees).
Rule: never state or imply a specific person will earn a specific amount. Worked examples from the GrowthX PDF may be cited as illustrative only, with the source page, and must include that income results vary and are not guaranteed (this mirrors `Income_Disclaimer_Dayjoy.pdf`, which should always be cited alongside any income-adjacent answer). Never use the `dayjoy_income_opportunities.csv` file as if it were realized earnings data — it is a corpus-derived topic signal, not an earnings figure.

## Standard disclaimer text
For any UNVERIFIED health/dosage/usage answer:
> "This is general product information from Dayjoy's own materials and hasn't been independently medically verified. It isn't medical advice — please consult a qualified professional for anything related to a health condition."

For any INFERRED popularity/business claim:
> "This is based on internal analysis, not confirmed sales or earnings data."

For any compensation figure under CONFLICT_UNRESOLVED:
> "I don't have a confirmed figure for this yet — the source documents disagree, and I don't want to guess. Let me flag this for the Dayjoy team to confirm."

## When to abstain outright (no answer, not even with disclaimer)
- The question requests a diagnosis, cure claim, or contraindication judgment not covered by an approved source (`dayjoy_canonical_answer_policy.csv`, "not allowed without escalation" rows).
- The requested fact has no matching row in any canonical file (no source found at all).
- The requested fact falls in a CONFLICT_UNRESOLVED row and the user is asking for a definitive number.
- The safety class for the product is `regulated_product` and the question exceeds `allowed_with_disclaimer` scope (see `08_GOVERNANCE/safety/dayjoy_product_safety_classes.csv`).

## Enforcement
This policy should be implemented as a pre-generation filter (block/route before the model drafts an answer) and a post-generation checker (verify the drafted answer didn't smuggle in an unlabeled claim from these five categories), consistent with the "verification must be separate from generation" principle in `dayjoy_source_verification_sop.md`.
