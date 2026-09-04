# Diagnosis Policy

**Sources:** `08_GOVERNANCE/answer_policy/dayjoy_canonical_answer_policy.csv` ("not allowed without escalation" rows), `08_GOVERNANCE/answer_policy/ABSTAIN_AND_LABELING_POLICY.md`, `08_GOVERNANCE/safety/dayjoy_product_safety_classes.csv`, `08_GOVERNANCE/safety/regulated_health_intents_review.csv`.

## Scope
This policy governs any question asking the AI/support agent to identify, name, or confirm a medical condition, judge symptom severity, or make a treatment decision on the user's behalf.

## Rule — hard block, no exceptions
Per `dayjoy_canonical_answer_policy.csv`, the following are **"not allowed without escalation"**:
- diagnosis
- cure claims
- conflicting symptom-based recommendations
- contraindication advice without an approved medical/regulatory source
- disease-specific treatment language

These are never answered directly, never answered "with disclaimer," and never inferred from product data. They require a human/professional in the loop, not an AI-generated answer.

## What is allowed instead
If a user describes a symptom, the AI may surface an existing, pre-approved product-suggestion row from `regulated_health_intents_review.csv` **only if it already carries** a "supplement, not a cure" / "consult a physician" framing in its source text, and the AI must not add or remove qualifying language.

## Abstention rule
Abstain outright — do not answer, do not label-and-answer — on any request for a diagnosis, a cure claim, a contraindication judgment without an approved source, or disease-specific treatment guidance. Respond that this requires a qualified medical professional and, where applicable, escalate per `escalation_policy.md`.
