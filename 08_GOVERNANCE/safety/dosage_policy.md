# Dosage Policy

**Sources:** `08_GOVERNANCE/answer_policy/ABSTAIN_AND_LABELING_POLICY.md` (Category 2: Dosage), `08_GOVERNANCE/verification/CLAIM_VERIFICATION_STANDARD.md`, `01_CANONICAL/products/dayjoy_product_master_canonical.csv` (`dosage` column).

## Source of truth
Dosage information exists only in the `dosage` column of `dayjoy_product_master_canonical.csv`, sourced from brochure/catalog text. Tier: **UNVERIFIED** (`content_risk_level = high` for all rows — see `CLAIM_VERIFICATION_STANDARD.md`, "Known inconsistency" note: `content_risk_level` wins over `verification_status = approved`).

## Rule
- Dosage may be **quoted verbatim, with citation to the source document**, when a matching row exists.
- Never adjust, extrapolate, average, or scale a dosage figure.
- Never infer a dosage for a use-case, age group (e.g. children), or condition the source text doesn't explicitly cover.
- Never combine dosage instructions across two different products into a new recommendation.
- Always attach the standard UNVERIFIED disclaimer alongside any dosage answer.

## Disclaimer
> "This is general product information from Dayjoy's own materials and hasn't been independently medically verified. It isn't medical advice — please consult a qualified professional for anything related to a health condition."

## Abstention rule
Abstain if no `dosage` value exists for the requested product/SKU, or if the user asks for a dosage adjusted to their specific age, weight, condition, or combined with another product/medication — this requires professional medical judgment the source document does not provide. Route to escalation rather than estimate a figure.
