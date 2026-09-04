No support/SLA material exists in the source knowledge base yet. See KNOWLEDGE_GAP_REPORT.md / MISSING_DATA_TASKS.csv.

## Update (2026-08-09)
This folder now contains a first pass at customer-support structuring, built entirely from real content already present elsewhere in this repository (the 3 canonical policy PDFs, `dayjoy_intents_CANONICAL.csv`, `dayjoy_faq_combined_canonical.csv`, `dayjoy_company_knowledge.csv`, and `08_GOVERNANCE/`). It does **not** invent new Dayjoy facts — genuine gaps (no SLA data, no dedicated Shipping/Refund Policy document, no privacy policy document) are marked NULL/UNVERIFIED with an explanatory note rather than filled in.

Files:
- `support_intents.csv` — 17 support intents with example questions and verification status.
- `support_policies.csv` — policy statements pulled verbatim from the 3 policy PDFs; one row (`POL-GAP-01`) documents a confirmed gap (a "Shipping/Refund Policy" is cited elsewhere in this repo's intents dataset but the document itself does not exist here).
- `support_decision_tree.md` — User Problem → Intent Detection → Required Information → Policy Lookup → Allowed Action → Resolution/Escalation, with 4 worked examples.
- `support_escalation_rules.csv` — 10 escalation rules derived from the answer policy, abstain policy, and compensation conflicts.
- `support_sla.csv` — all target response times are NULL; no SLA data exists anywhere in this repo (also flagged in `dayjoy_company_knowledge.csv` CK061).
- `support_contacts.csv` — only contact info independently verified against primary sources (GrowthX OCR, Payment Gateway Policy PDF, company overview CSV); one row flags a genuine phone-number conflict.
- `support_required_information.csv`, `support_allowed_actions.csv`, `support_prohibited_promises.csv` — the first two are DRAFT process scaffolding pending support-team sign-off (explicitly labeled as such in their header row); the prohibited-promises file is sourced directly from `ABSTAIN_AND_LABELING_POLICY.md` and the 3 policy PDFs.

See also `08_GOVERNANCE/safety/` for the 8 policy documents (medical, product, dosage, diagnosis, income, compensation, privacy, escalation) that govern how these support intents may be answered.


## File-level notes (moved out of CSV headers for valid CSV parsing)
- HEADER NOTE: DRAFT process definitions pending support-team sign-off, except where a source_document is listed — those rows are directly sourced from ABSTAIN_AND_LABELING_POLICY.md and the 3 canonical policy PDFs, not invented.
- HEADER NOTE: DRAFT process definitions pending support-team sign-off. This file describes reasonable information-gathering scaffolding for the intents in support_intents.csv; it is NOT a documented Dayjoy operational requirement unless a source_document is listed below.
- HEADER NOTE: DRAFT process definitions pending support-team sign-off. These are reasonable actions an AI/support agent could take for each intent given the governance docs in 08_GOVERNANCE/; they are NOT a documented Dayjoy operational procedure unless a source_document is listed below.
