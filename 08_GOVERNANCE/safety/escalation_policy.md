# Escalation Policy

**Sources:** `08_GOVERNANCE/answer_policy/dayjoy_canonical_answer_policy.csv` ("not allowed without escalation" rows), `08_GOVERNANCE/answer_policy/ABSTAIN_AND_LABELING_POLICY.md`, `01_CANONICAL/compensation/dayjoy_compensation_conflicts.csv`, `01_CANONICAL/policies/PaymentGatewayPolicy_Dayjoy.pdf`.

## Trigger conditions requiring escalation (never answered by AI alone)
From `dayjoy_canonical_answer_policy.csv`, topic = "not allowed without escalation":
1. **diagnosis** — a request to name/confirm a medical condition.
2. **cure claims** — a request to confirm a product cures a condition.
3. **conflicting symptom-based recommendations** — where multiple products/answers conflict for the same symptom.
4. **contraindication advice without approved medical/regulatory source** — safety interactions not covered by an approved document.
5. **disease-specific treatment language** — treatment guidance tied to a named disease.

## Additional escalation triggers (derived from other governance docs)
6. **CONFLICT_UNRESOLVED compensation fields** (retail profit %, mentorship bonus %, business matching structure) — per `dayjoy_compensation_conflicts.csv` and `compensation_policy.md` — route to the Dayjoy compensation team.
7. **Payment issues** — `PaymentGatewayPolicy_Dayjoy.pdf` explicitly directs payment problems to Customer Care at +91-7733990555 or support@dayjoy.in, quoting the order number; this is a documented human-handoff, not an AI-answerable flow.
8. **No source found at all** for a requested fact — per `CLAIM_VERIFICATION_STANDARD.md`, "no source found → abstain," which for a live support interaction means escalate to a human agent rather than leave the user with nothing.

## Escalation destination
- Medical/diagnosis/cure/contraindication topics → human support agent instructed to direct the user to a qualified medical professional (never an internal "medical team," since no such team is documented in this repo).
- Compensation conflicts → Dayjoy compensation/distributor-support team.
- Payment issues → Dayjoy Customer Care (+91-7733990555 / support@dayjoy.in), per the Payment Gateway Policy.
- Unsourced/unknown facts → general human support queue.

## Abstention rule
When a trigger condition above is met, the AI must not draft a substantive answer even with a disclaimer — it must state that the topic requires human review, name the escalation destination where known, and stop. Never let escalation triggers be silently downgraded to a "disclaimer-only" answer.
