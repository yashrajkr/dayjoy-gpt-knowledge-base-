# Support Decision Tree

Status note: this document maps the flow of an actual support interaction using only real repo content (`support_intents.csv`, `support_policies.csv`, `08_GOVERNANCE/answer_policy/`, `08_GOVERNANCE/safety/`). The flow structure itself (steps, ordering) is DRAFT process scaffolding pending support-team sign-off — see `support_required_information.csv` header note.

## Flow
**1. User Problem** — the raw message from the customer/distributor.
→ **2. Intent Detection** — match against `support_intents.csv` (intent_id).
→ **3. Required Information** — check `support_required_information.csv` for what's needed to act on that intent.
→ **4. Policy Lookup** — check `support_policies.csv` (support-ops facts) and `08_GOVERNANCE/answer_policy/dayjoy_canonical_answer_policy.csv` (what's allowed to answer directly vs. with disclaimer vs. escalate).
→ **5. Allowed Action** — check `support_allowed_actions.csv` for what the agent/AI may actually do.
→ **6. Resolution OR Escalation** — per `support_escalation_rules.csv`.

## Worked example 1 — Payment issue (SI007)
1. User: "My payment failed but money was deducted."
2. Intent detected: `SI007 payment_issue`.
3. Required info: order number, payment method, approximate time of transaction.
4. Policy lookup: `POL-PAY-05` (PaymentGatewayPolicy_Dayjoy.pdf) — instructs routing to Customer Care with the order number.
5. Allowed action: acknowledge, collect order number, provide Customer Care contact.
6. Resolution: this is a documented human-handoff in the source policy itself — escalate to Customer Care (+91-7733990555 / support@dayjoy.in) per `support_contacts.csv`, not resolved by AI alone.

## Worked example 2 — Product price/BV inquiry (SI013)
1. User: "What is the price and BV of Black Salt Sprinkler (200g)?"
2. Intent detected: `SI013 price_bv_inquiry`.
3. Required info: product name or SKU.
4. Policy lookup: price/DP/BV is "allowed directly" per `dayjoy_canonical_answer_policy.csv`.
5. Allowed action: answer directly, cite `India BV Price May 2026.pdf` / `dayjoy_price_list_may2026.csv`.
6. Resolution: answered directly, no escalation needed.

## Worked example 3 — Symptom/diagnosis question (SI017)
1. User: "I have Fatigue, what should I take? Will it cure it?"
2. Intent detected: `SI017 diagnosis_or_symptom_recommendation`.
3. Required info: none that changes the outcome — this intent is governed, not information-gated.
4. Policy lookup: `diagnosis_policy.md` / `medical_claim_policy.md` — "cure claims" and "diagnosis" are "not allowed without escalation" per `dayjoy_canonical_answer_policy.csv`.
5. Allowed action: may surface the pre-approved supplement suggestion from `regulated_health_intents_review.csv` with its existing disclaimer intact, but must not confirm a cure.
6. Resolution: partial answer (labeled, disclaimed) + escalate the cure/diagnosis portion — never a flat "yes it cures X."

## Worked example 4 — Shipping/return question (SI001-SI006)
1. User: "Can I return this product?"
2. Intent detected: `SI002 product_return`.
3. Required info: order number, invoice date, product condition.
4. Policy lookup: `support_policies.csv` `POL-GAP-01` — the underlying "Shipping/Refund Policy" document is **not present in this repo**.
5. Allowed action: acknowledge the request, collect order details, do NOT quote specific return-window/handling-charge figures as confirmed policy.
6. Resolution: escalate to human support / Dayjoy team to supply the actual policy and complete the request — this is a known knowledge gap, not a resolvable AI answer.
