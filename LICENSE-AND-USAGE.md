# License and Usage

## Ownership
All source documents in `00_SOURCE_DOCUMENTS/` (brochures, price lists, policy PDFs, the GrowthX compensation deck, company documents) are Dayjoy's own materials, supplied by the user. This repository organizes and derives from them; it does not change their ownership or grant any third-party rights.

## Internal use
This repository is intended for internal Dayjoy use — building and governing an AI assistant, internal tooling, training material, and analytics. It is not licensed for external redistribution, resale, or publication of the source documents themselves.

## Non-negotiable rule for downstream use
Any system, service, or document that consumes data from this repository — the AI Brain, a dashboard, a report, a chatbot — **must preserve the verification tier** (VERIFIED / UNVERIFIED / INFERRED, per `08_GOVERNANCE/verification/CLAIM_VERIFICATION_STANDARD.md`) when it surfaces the following categories of claim:

- Health benefits, dosage, ingredients, usage, or contraindications
- Compensation plan figures, ranks, or incentive structures
- "Best-selling," "popular," or ranking claims about products
- Business, earnings, or income-related claims

Stripping the tier label when reusing this data (e.g., copying `benefits` text into marketing copy without the UNVERIFIED framing, or citing `dayjoy_best_selling_products.csv` as confirmed sales data) reintroduces the exact risk this repository's governance layer exists to prevent. See `08_GOVERNANCE/answer_policy/ABSTAIN_AND_LABELING_POLICY.md` for the specific required framing per category.

## Regulated content
Compensation/income claims and health-adjacent product claims are subject to Dayjoy's own compliance policies, included as source documents (`Income_Disclaimer_Dayjoy.pdf`, `Social_Media_Policy_Dayjoy.pdf`, `PaymentGatewayPolicy_Dayjoy.pdf` in `00_SOURCE_DOCUMENTS/policies/` and `01_CANONICAL/policies/`). Anything generated from this repository that touches income or health claims should be checked against those policies before external use, independent of the AI-specific governance layer here.

## No warranty on unresolved items
Data flagged `CONFLICT_UNRESOLVED`, `UNMATCHED`, or noted as a gap in `PRODUCTION_READINESS_REPORT.md` carries no guarantee of accuracy. Do not treat silence on a topic as confirmation — check `09_QA/KNOWLEDGE_GAP_REPORT.md` and the relevant folder README before assuming completeness.
