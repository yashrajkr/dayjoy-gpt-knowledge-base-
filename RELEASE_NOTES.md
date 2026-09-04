# Release Notes — v3.0.0-integration-ready

## What this release is

The Dayjoy Knowledge Base, completed across all 26 requested phases: source registry, product/pricing masters, company knowledge, compensation knowledge, distributor training, FAQ, customer support, product relationship graph, AI intent dataset, RAG dataset + retrieval strategy, knowledge graph, AI memory schemas, business analytics schemas, conversation/voice datasets, safety & governance policies, evaluation dataset, golden dataset, full PostgreSQL/Supabase schema, image knowledge, web-knowledge separation policy, and versioning/cross-validation/quality-scoring/final-audit reports.

## Headline numbers

- 170 canonical products, 0 duplicate IDs/SKUs, 0 orphan cross-file references anywhere checked.
- 1,897 FAQ rows, 1,531+95 structured/synthetic intents, 2,242 RAG chunks, 4,119 relationship edges, 2,434 knowledge-graph nodes.
- 81 compensation rules (48 VERIFIED / 30 UNVERIFIED / 3 CONFLICT), 30 training lessons, 65 company-knowledge facts.
- 1,060 evaluation questions + 220 golden questions (169 + 51 new).
- 27 new SQL tables covering the full requested entity list, all business-data tables schema-only (no fabricated rows).
- Overall KB quality score: ~85/100. Full breakdown: `DATA_QUALITY_SCORING.md`.

## What changed from the last release (v2.1.0-audited)

See `CHANGELOG.md`'s `3.0.0-integration-ready` entry for the complete file-by-file list. In short: every previously-placeholder folder (company, support, training, compensation-rules, knowledge_graph, and the new memory/web folders) now has real, sourced content instead of a README stub — this directly addresses the gap where "many folders had only a README file."

## What this release is NOT

Not a claim that every Dayjoy fact is confirmed. Not a claim that the RAG corpus is deduplicated (61% of chunks are redundant placeholder text — documented, not hidden). Not a claim that compensation figures are fully resolved (3 known conflicts, plus a newly-discovered second compensation document that disagrees with the verified one). See `PRODUCTION_READINESS.md` for the full blocker list and the exact FINAL STATUS verdict: **READY FOR INTEGRATION**, not yet PRODUCTION READY.

## Where to start

1. `PRODUCTION_READINESS.md` — the 15-question final audit and the 5 named blockers.
2. `DATA_QUALITY_SCORING.md` — per-dataset 0-100 scores with justification.
3. `CROSS_DATA_VALIDATION_REPORT.md` — every integrity check run this pass, plus the two significant new findings (missing Shipping/Refund Policy source, second compensation document).
4. `KNOWLEDGE_MAP.md` — one-page folder-by-folder status.
5. `06_REMAINING_GAPS.csv` — the full itemized gap list with who needs to act on each.
