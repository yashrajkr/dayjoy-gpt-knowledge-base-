# Audit Trail

This folder holds the original repository-wide audit artifacts produced before any canonical data was built, plus the ongoing change log.

- `FILE_INVENTORY.md`, `file_inventory_full_raw_audit.csv` — full inventory of all 1,803 raw file records discovered across the original messy source folder (nested zips unpacked up to 8 levels), with SHA-256 hashes.
- `DUPLICATE_REPORT.md` — exact-duplicate and version-cluster findings from that inventory.
- `OUTDATED_FILES.md` — superseded-file findings.
- `MISSING_KNOWLEDGE.md` — preliminary gap scan (superseded by the fuller `09_QA/KNOWLEDGE_GAP_REPORT.md`).
- `PROPOSED_STRUCTURE.md` — the original structure proposal presented for approval before any files were built.

For the current, authoritative source registry (what's canonical now and why), see `08_GOVERNANCE/source_registry/`. For open verification questions, see `08_GOVERNANCE/verification/`. This audit folder is historical record, not a live control — don't edit these files; if a new audit is run, add new dated files rather than overwriting.
