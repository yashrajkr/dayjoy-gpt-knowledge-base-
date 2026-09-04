# Dayjoy AI Assist — Production Knowledge Checklist

Generated: 2026-08-09.

- [x] Product master — pricing/identity complete, descriptive content partial (170/170 SKUs have verified pricing; ingredients 50/170, benefits 131/170, warnings 1/170)
- [x] Pricing — verified cross-pipeline, sourced from official BV price PDF
- [ ] Company — structured fields incomplete (T012)
- [ ] Compensation — critical gap, only a stub exists (T003)
- [ ] Training — does not exist (T009-T011)
- [x] FAQ — 1,884 Q&A pairs, full 170-SKU coverage
- [ ] Support — does not exist (T005-T008)
- [ ] Product relationships — data exists, 62KB of open review items unresolved (T016)
- [ ] Intent dataset — two unreconciled parallel sets (T013)
- [ ] RAG chunks — two unreconciled parallel sets (T014)
- [ ] Metadata — canonical registry exists for one RAG pipeline only
- [ ] SQL — two schema files never diffed against each other (T015)
- [ ] Images — zero actual image files exist anywhere (T002)
- [ ] Governance — policy/safety scaffolding exists structurally, needs domain-expert sign-off
- [ ] Safety — safety-class data exists, needs sign-off
- [ ] Evaluation — no real evaluation has been run yet
- [ ] Golden questions — do not exist (T004)
- [x] Source registry — full provenance for all 1,803 file records in `08_GOVERNANCE/source_registry/file_inventory.csv`
- [x] Versioning — `VERSION` + `CHANGELOG.md` established for this organized tree
- [x] Audit trail — `99_ARCHIVE/archive_manifest.csv` covers all 1,832 non-canonical records

**Bottom line: not production-ready.** Pricing, FAQ, and provenance/governance scaffolding are solid. Compensation, images, training, support, and evaluation (golden questions) are the blockers — all four are CRITICAL or HIGH items in `09_QA/KNOWLEDGE_GAP_REPORT.md` / `09_QA/MISSING_DATA_TASKS.csv`, and none of them can be safely filled by AI generation — they all require an official Dayjoy source document or team input per your rule against inventing facts.
