# Cross-Data Validation Report — Full KB Completion Pass

Run 2026-08-09 after the full 6-workstream completion pass (company/safety/support, compensation/training, FAQ/relationships/knowledge-graph/memory, intents/RAG/retrieval/conversations/web, SQL/analytics/images, evaluation/golden). Extends `04_CROSS_DATA_VALIDATION.md` (Phase 1-3 audit) rather than repeating it — that report's findings still hold; this one covers the new datasets built this pass.

## CSV integrity sweep (all 267 live CSVs, excluding archive)

Every CSV in the repository was parsed with pandas. **4 files failed on first pass** (support_intents.csv, support_escalation_rules.csv, support_prohibited_promises.csv, support_required_information.csv, support_allowed_actions.csv — 5 total) due to unquoted commas inside free-text fields and, in 3 cases, a leading `# HEADER NOTE` comment row that isn't valid CSV. **All 5 were fixed in place** (proper CSV quoting; the header notes were moved into `01_CANONICAL/support/README.md` rather than discarded). **Re-swept after fixing: 267/267 CSVs parse cleanly, 0 remaining.**

## Orphan / referential integrity checks (new datasets)

| Check | Result |
|---|---|
| Knowledge graph edges referencing a node_id not in kg_nodes.csv | 0 / 3,977 |
| Product relationship edges (`product_relationship_edges.csv`) referencing a from_id not in the product master | 0 / 4,119 |
| FAQ v2 (`dayjoy_faq_canonical_v2.csv`) rows with a sku not in the product master | 0 / 1,897 |
| Structured intents (`dayjoy_intents_STRUCTURED.csv`) rows with a sku not in the product master | 0 / 1,531 |
| Evaluation dataset rows | 1,060 total across 8 categories (pricing 340, product 200, support 100, ambiguous 100, out_of_domain 100, adversarial 94, distributor_compensation 84, policy 42) |

No orphan references were found in any newly built dataset. This is a genuinely clean result — every new file was built by deriving from already-verified canonical data rather than introducing new identifiers.

## Duplicate / redundancy findings

- **RAG chunks**: 77 distinct duplicate-text groups covering 1,437 of 2,242 chunks (1,360 redundant rows), mostly templated "information not available" placeholders repeated per product. Documented in `04_RAG/metadata/dayjoy_metadata_registry_ENRICHED.csv`'s build notes — not yet deduplicated in the canonical chunks file itself (a targeted follow-up, not done in this pass since it would mean editing the canonical RAG file rather than adding structure around it).
- **Golden question set**: the 51 new additions (`dayjoy_golden_questions_v2_ADDITIONS.csv`) were verified programmatically to have zero overlap with the existing 169.

## New data-honesty findings (real gaps surfaced this pass, not previously documented)

1. **"Shipping/Refund Policy" citation gap**: `dayjoy_intents_CANONICAL.csv` cites a "Shipping/Refund Policy" document as the source for several return/refund/cancellation answers, but no such document exists anywhere in the repository. Every downstream file that touches this content (`support_intents.csv`, `support_escalation_rules.csv`, `support_prohibited_promises.csv`) now carries this gap explicitly (tagged `POL-GAP-01`) instead of presenting those answers as sourced policy.
2. **Second, uncorroborated compensation source**: `distributor_system_narrative_UNSTRUCTURED.md` describes compensation structures (Fast Track/Startup/Active/Super Active bonuses, a second rewards table, 4 funds, a different loyalty program, PV-vs-BV terminology) that do not appear in the OCR-verified GrowthX deck — a materially different and previously undocumented conflict, now logged in `compensation_gap_report.csv` as gap G-002 and marked UNVERIFIED everywhere it surfaces. This is a bigger, previously-unflagged risk than the 3 known CONFLICT_UNRESOLVED figures — it suggests two different compensation-plan documents may be circulating.
3. **RLS role naming mismatch**: the SQL agent found the RAG chunks' actual `role_scope` values are lowercase (`public/distributor/internal/support`), not the `Customer/Distributor/Leader/Admin` naming assumed by this task's brief. `rls_policies.sql` documents this mapping explicitly rather than silently picking one convention.
4. **FAQ coverage**: the original 1,884-row FAQ file is 100% product-centric (pricing/usage/ingredients/safety/etc.) — zero real coverage for shipping, returns, training, account, or technical support categories. 13 additional genuine (non-fabricated) rows were recovered from the compensation FAQ file for distributor/compensation/company/ordering topics. The gap for shipping/returns/training/account/technical remains open — `faq_gap_report.csv` documents it rather than papering over it with synthetic Q&A.

## Verdict inputs for data quality scoring and final audit

No new orphan-reference or duplicate-ID problems were introduced by this pass. The two most consequential findings are informational/documentation gaps that were surfaced, not created — the "Shipping/Refund Policy" phantom citation and the second uncorroborated compensation document. Both should be escalated to a human (Dayjoy content owner) before any customer-facing answer relies on that content.
