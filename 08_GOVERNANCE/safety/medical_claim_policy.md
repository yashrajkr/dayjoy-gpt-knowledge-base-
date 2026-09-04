# Medical Claim Policy

**Sources:** `08_GOVERNANCE/answer_policy/dayjoy_canonical_answer_policy.csv`, `08_GOVERNANCE/answer_policy/ABSTAIN_AND_LABELING_POLICY.md` (Category 1: Health benefits), `08_GOVERNANCE/verification/CLAIM_VERIFICATION_STANDARD.md`, `08_GOVERNANCE/safety/dayjoy_product_safety_classes.csv`, `08_GOVERNANCE/safety/regulated_health_intents_review.csv`.

## What counts as a medical claim
Any statement that a Dayjoy product treats, prevents, cures, or manages a named disease or medical condition; any statement implying clinical/medical efficacy beyond general wellness positioning.

## Rule
- Product `benefits`/`usage` text drawn from brochure/catalog sources (`dayjoy_product_master_canonical.csv`) is tier **UNVERIFIED** — `content_risk_level = high` for all 170 rows per `CLAIM_VERIFICATION_STANDARD.md`. It may be **summarized only with citation to the source brochure and the standard disclaimer** — never stated as a medically proven fact.
- Products flagged `regulated_product` in `dayjoy_product_safety_classes.csv` may only receive `product overview`, `general usage summary from approved brochure`, and `compliance statements if approved source exists` — all `allowed with citation + disclaimer`, never as flat fact.
- Symptom-to-product rows in `regulated_health_intents_review.csv` already carry a "this is a supplement, not a cure" / "consult a physician" disclaimer in their source answer text — that disclaimer must always be preserved and never stripped when reusing these answers.

## Disclaimer (mandatory whenever a health/benefit claim is surfaced)
> "This is general product information from Dayjoy's own materials and hasn't been independently medically verified. It isn't medical advice — please consult a qualified professional for anything related to a health condition."

## Abstention rule
Abstain outright (no answer, not even with disclaimer) if the question asks Dayjoy to confirm a product "cures," "treats," or is "medically proven" for a named disease, or if the safety class is `regulated_product` and the question exceeds `allowed_with_disclaimer` scope. Route to human/medical-professional escalation instead of answering.
