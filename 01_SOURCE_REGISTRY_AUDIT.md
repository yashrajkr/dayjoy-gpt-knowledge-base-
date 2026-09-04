# Phase 1 — Source Registry Audit

Scope: does `source_registry.csv` (or equivalent) exist with at minimum: `source_id, filename, source_type, source_url, date_obtained, document_date, version, authority, status, checksum, supersedes, notes`?

Audit performed against the repository at `Dayjoy-Knowledge-Base/` on 2026-08-09. Read-only audit — nothing in the repository was modified, moved, or deleted.

---

## Executive Verdict: READY WITH FIXES

No file literally named `source_registry.csv` exists anywhere in the repository (confirmed by a repo-wide filename search — zero hits). What exists is `08_GOVERNANCE/source_registry/file_inventory.csv`, and its own governing document (`08_GOVERNANCE/audit/PROPOSED_STRUCTURE.md`, line 71) explicitly states the design intent: *"file_inventory.csv + provenance chains become the source registry."* So this file is meant to serve the role, but it is a **raw extraction/deduplication inventory** (1,803 records = every original file plus everything recursively unpacked from nested ZIPs, up to 8 levels deep), not a curated per-source-document registry. Of its 10 columns, only 2 map directly to the 12 requested columns (`file_id`→`source_id`, `sha256`→`checksum`); the other 8 requested columns (`source_type, source_url, date_obtained, document_date, version, authority, status, supersedes`) do not exist as structured data anywhere in the repository — confirmed by grep across all CSV/MD files. This is a genuine, material gap, not a naming technicality.

The reason this is **READY WITH FIXES** rather than **NOT READY**: the underlying raw material is sound and largely sufficient to build the missing columns without new research. There are only **11 actual physical source documents** on disk (not 1,803 — that number is dominated by 94% duplicate noise from nested-ZIP re-bundling, already diagnosed in the existing audit trail). The facts needed to populate the 8 missing columns for those 11 documents already exist in prose form elsewhere in the repo: the verification SOP defines an authority-priority hierarchy, `OUTDATED_FILES.md` documents supersession relationships, and file sizes/hashes/paths are already captured with verified integrity. The work required is consolidation and manual population of ~11 rows × 8 new columns, not a data-collection project. Checksums that do exist are structurally sound and verified accurate on spot-check.

---

## Column-by-Column Check

| Requested column | Status | Where |
|---|---|---|
| `source_id` | **Partial** | `file_inventory.csv` has `file_id` (F00001–F01803), but it's a raw-record ID, not a curated one-per-source-document ID — one physical document maps to up to 7 `file_id` rows because of duplicate ZIP copies |
| `filename` | **Exists** | `file_inventory.csv` → `filename` column, populated for all 1,803 rows |
| `source_type` | **Missing** | No column anywhere. Appears only as a *planned* field name in `04_RAG/metadata/dayjoy_rag_knowledge_schema.csv` (row 2, describing a future ingestion pipeline) and as a conceptual "Approved source hierarchy" table in `08_GOVERNANCE/verification/dayjoy_source_verification_sop.md` — neither is populated per-file |
| `source_url` | **Missing** | No column in `file_inventory.csv`. A `url` column exists in `00_SOURCE_DOCUMENTS/website_snapshots/website_snapshot_log.csv`, but that file has **0 data rows** (header only) — it's a template for a website-snapshot category that is deliberately empty; it is not linked to `file_inventory.csv` in any way |
| `date_obtained` | **Missing** | No date column of any kind exists in `file_inventory.csv` (only `size`, `file_type`, hash, path) |
| `document_date` | **Missing** | Same as above — no document-dating field anywhere in the registry |
| `version` | **Missing** | No structured version field. `provenance_chain` is a free-text path string, not a version identifier. Version/supersession relationships are documented only in prose in `08_GOVERNANCE/audit/OUTDATED_FILES.md` |
| `authority` | **Missing** | No per-file authority/official-vs-unofficial column anywhere. Closest analog: the SOP's 4-tier "Approved source hierarchy" (1=price list/policy, 2=approved brochure, 3=FAQ corpus, 4=internal structured dataset) — this is policy guidance, not a value applied to any specific registry row |
| `status` | **Missing** | No `status`/`approval_status` column in `file_inventory.csv`. `CLAIM_VERIFICATION_STANDARD.md` defines VERIFIED/UNVERIFIED/INFERRED tiers, but those apply to canonical **claims/datasets** in `01_CANONICAL/`, `04_RAG/`, `07_ANALYTICS/` — not to source documents in the registry |
| `checksum` | **Exists** | Maps directly to `sha256` in `file_inventory.csv`. All 1,803 rows populated, structurally valid, spot-verified (see Check 3 below) |
| `supersedes` | **Missing** | No structured column. Supersession is documented only in prose, file-by-file, in `08_GOVERNANCE/audit/OUTDATED_FILES.md` (e.g., "`dayjoy-rag-chunks.csv` (2,197 rows) superseded by `dayjoy-rag-chunks-final.csv` (2,242 rows)") |
| `notes` | **Missing** | No free-text notes column in `file_inventory.csv` itself |

**Net: 2 of 12 requested columns exist (source_id partially, checksum fully); 10 of 12 are partial-or-missing; 8 of 12 are completely absent as structured per-file data.**

---

## Detailed Findings

### 1. Inventory inspection and cross-reference
- `08_GOVERNANCE/source_registry/file_inventory.csv`: **1,803 data rows**, header exactly `file_id,filename,extracted_path,provenance_chain,depth,size,file_type,sha256,duplicate_group,exact_dup_count` — confirmed by direct read.
- Per `08_GOVERNANCE/audit/FILE_INVENTORY.md`, this 1,803-row count represents every original file **plus** everything found recursively inside every ZIP (nested up to 8 levels) — it is an as-received extraction audit, not a curated document list. Only **440 of 1,803 rows have genuinely unique content** by SHA-256.
- `08_GOVERNANCE/source_registry/catalog86_merge_audit.csv`: 91 rows, unrelated to source registration — it's a product-catalog matching audit (catalog86 name → matched SKU/canonical name/confidence), not part of the source registry schema.
- `08_GOVERNANCE/source_registry/ocr_extracts/`: contains exactly 1 file (`GrowthX_Plan_Presentation_OCR_full_text.txt`) — an OCR dump used to verify one specific compensation document, not a registry component.
- Historical audit reports read in full: `FILE_INVENTORY.md`, `DUPLICATE_REPORT.md`, `OUTDATED_FILES.md`, `PROPOSED_STRUCTURE.md`, `README.md` (all in `08_GOVERNANCE/audit/`). These confirm the 1,803/440/1,696 figures independently and describe the fractal-ZIP-nesting root cause of the duplication. `PROPOSED_STRUCTURE.md` explicitly names `file_inventory.csv` as the intended source registry, confirming it's serving that role today, in an incomplete form.

### 2. Column verification
Done directly against the CSV headers and by repo-wide grep for `source_type`, `date_obtained`, `document_date`, `supersedes` — see column table above. No hidden/renamed equivalents were found beyond the ones already noted (`dayjoy_rag_knowledge_schema.csv`'s aspirational `source_type` field, `website_snapshot_log.csv`'s unused `url`/`capture_date` fields).

### 3. Checksum structural validation
- Script-verified: **all 1,803 rows have a populated `sha256` value; 100% are exactly 64 hex characters (0 empty, 0 malformed, 0 wrong-length).**
- Spot-checked 8 randomly sampled rows (seeded random sample) by re-reading the actual file at `extracted_path` and independently recomputing SHA-256 and file size: **8/8 matched the recorded checksum, 8/8 matched the recorded size.** Checksum data is trustworthy where present.
- Caveat: `extracted_path` values are **absolute paths tied to a specific sandbox session mount** (e.g. `/sessions/.../mnt/dayjoy-ai-assist knowledge base/...`), not relative paths anchored to the repo root. They happened to resolve correctly in this audit environment, but this is not a portable design — if the repository is copied elsewhere, every `extracted_path` breaks. Worth fixing regardless of the missing-columns issue.

### 4. Duplicate detection
- `duplicate_group`/`exact_dup_count` columns are populated and internally consistent: **333 distinct duplicate groups**, covering **1,696 of 1,803 rows (94%)**; **107 rows have no duplicate_group (i.e., unique)**. 333 + 107 = 440, matching the audit's independently-stated unique-content count exactly.
- Largest duplicate group: `DG0020` at 34 copies (matches `DUPLICATE_REPORT.md`'s top entry, `dayjoy_products_master.csv` found 34 times). Several other groups at 32–33 copies. Cross-checked and consistent with the prior audit's published table.

### 5. Official vs. unofficial / authority classification
**Does not exist as a per-source attribute anywhere.** Checked `08_GOVERNANCE/verification/`:
- `dayjoy_source_verification_sop.md` — defines a 4-tier "Approved source hierarchy" (price list/policy > approved brochure > FAQ corpus > internal structured dataset) as **policy guidance**, and lists `document_id, source type, source owner, effective date, version, approval state, source hash` as required onboarding fields — but this is a target-state SOP, not implemented data. No file in the repo actually carries these tags.
- `dayjoy_verification_watchlist.csv` (5 rows) — tracks product-level pack-size gaps, unrelated to source authority.
- `dayjoy_data_qa_report.csv` (7 checks) — canonical product-master QA pass/fail, unrelated to source authority.
- `CLAIM_VERIFICATION_STANDARD.md` — defines VERIFIED/UNVERIFIED/INFERRED tiers, but these are applied to **canonical claims/datasets**, not to entries in the source registry itself.

### 6. Orphan check — source files on disk not in the registry
Cross-referenced every file under `00_SOURCE_DOCUMENTS/` and every PDF under `01_CANONICAL/*/` against `file_inventory.csv` **by recomputed SHA-256 content hash** (not filename — filename matching produced a false positive, see note below).

- `00_SOURCE_DOCUMENTS/` contains 14 files total; 11 are genuine source documents (3 brochures, 2 company docs, 1 compensation deck, 4 policy PDFs, 1 price list) and 3 are website-snapshot governance/template files.
- `01_CANONICAL/` contains 4 PDFs (policies + pricing), which are byte-identical copies of 4 of the 11 documents above.
- **All 11 genuine source documents + all 4 canonical PDF copies (15 files checked, 11 unique) were successfully matched to `file_inventory.csv` rows by independently recomputed SHA-256.**
- **3 files ARE orphans — present on disk, absent from the registry by content hash:**
  - `00_SOURCE_DOCUMENTS/website_snapshots/README.md`
  - `00_SOURCE_DOCUMENTS/website_snapshots/WEBSITE_SNAPSHOT_POLICY.md`
  - `00_SOURCE_DOCUMENTS/website_snapshots/website_snapshot_log.csv`

  Mitigating context: `WEBSITE_SNAPSHOT_POLICY.md` explicitly documents that this folder is **deliberately empty** — no website snapshot has ever been captured, and the policy states website content must be registered before use. These 3 files are governance/template documents about a not-yet-populated source category, not uncaptured source content. Still, strictly speaking, they are unregistered files sitting inside `00_SOURCE_DOCUMENTS/`.
  - **False-positive warning**: a naive filename-only match incorrectly flagged `website_snapshots/README.md` as "in registry" because `file_inventory.csv` contains two *unrelated* `README.md` files (`F00856`, `F01382`, from a different extraction path, different SHA-256: `c0f74b88...` vs. the actual file's `b18d68e4...`). This proves **filename alone is not a safe join key** for this registry — any consumer must join on `file_id` or `sha256`, not filename. This is itself a usability gap worth fixing.

### 7. Verdict rationale
See Executive Verdict above. Restated: 2/12 columns exist, 10/12 are partial or missing, 8/12 are completely absent — that's a real gap, not cosmetic. It is **READY WITH FIXES** rather than **NOT READY** because (a) the file counts and checksums that do exist are accurate and verified, (b) the scope is small — 11 real documents, not 1,803 — and (c) the facts needed for the missing columns already exist in readable prose elsewhere in the repo (SOP hierarchy, OUTDATED_FILES.md supersession notes), so this is assembly work, not new research or data collection.

---

## Specific Gaps (summary)

1. No file named `source_registry.csv` exists.
2. `file_inventory.csv` is a raw dedup/extraction audit of 1,803 records (94% duplicate noise), not a curated one-row-per-source-document registry.
3. 8 of 12 requested columns (`source_type, source_url, date_obtained, document_date, version, authority, status, supersedes`) do not exist as structured data anywhere in the repository.
4. No official/unofficial or authority-tier classification is applied to any actual file — only described as policy in the SOP.
5. `extracted_path` values are absolute, session-specific sandbox paths, not portable repo-relative paths.
6. 3 files under `00_SOURCE_DOCUMENTS/website_snapshots/` are not represented in `file_inventory.csv` at all (governance/template files for an intentionally-empty source category).
7. Filename is not a reliable join key against the registry (demonstrated false-positive collision on `README.md`); only `file_id`/`sha256` are safe.

## Non-Destructive Fixes That Would Move This to READY (not applied — audit only)

1. Create an actual `source_registry.csv` (or rename with a documented alias) scoped to the **11 genuine physical source documents**, not all 1,803 raw extraction records.
2. Map `file_id`→`source_id` and `sha256`→`checksum` directly from `file_inventory.csv` for those 11 rows.
3. Add `source_type` per document (brochure, price list, policy, compensation deck, company doc) — derivable from the existing `00_SOURCE_DOCUMENTS/` subfolder each file already lives in.
4. Add `authority` per document using the SOP's existing 4-tier hierarchy (price list/policy=1 down to internal dataset=4) — the ranking logic already exists in `dayjoy_source_verification_sop.md`, it just needs to be applied per file.
5. Add `document_date` / `date_obtained` — will require checking file metadata or asking the business owner for the remaining unknowns; not all of this may be recoverable from existing repo content and should be marked explicitly blank/unknown rather than guessed.
6. Add `version` / `supersedes` by transcribing the relationships already documented in prose in `08_GOVERNANCE/audit/OUTDATED_FILES.md`.
7. Add `status` (e.g., active/superseded/draft) — derivable in part from the duplicate/supersession analysis already done.
8. Add `source_url` only where applicable (none currently, since no website snapshot has been captured — leave blank per the existing "don't invent" policy in `WEBSITE_SNAPSHOT_POLICY.md`).
9. Register the 3 website_snapshots governance files somewhere (either in the new registry with a `governance_doc` type, or explicitly documented as out-of-scope for source registration).
10. Replace absolute sandbox paths in any new registry with repo-relative paths.
11. Document explicitly that filename is not a safe join key; use `source_id`/`checksum` in any downstream tooling.

---

## Stakeholder Summary (under 15 lines)

**Verdict: READY WITH FIXES.** No file named `source_registry.csv` exists. What exists (`file_inventory.csv`) is a raw 1,803-record extraction/dedup audit — 94% of it is duplicate noise from repeatedly re-zipped bundles — not a curated source registry. Only 2 of the 12 requested columns exist (`file_id`→source_id, `sha256`→checksum); the other 10 are missing or only partially present, and 8 are completely absent anywhere in the repo (source_type, source_url, date_obtained, document_date, version, authority, status, supersedes). Checksums that do exist are solid: all 1,803 rows have valid 64-char SHA-256 values, and an 8-file spot-check independently recomputing hashes and sizes matched 100%. There are only 11 real source documents on disk; all 11 were traced into `file_inventory.csv` by content hash. 3 files (website-snapshot governance/template docs, deliberately empty per existing policy) are not in the registry at all. No official-vs-unofficial source classification exists anywhere as data — only as unapplied SOP guidance. This is fixable without new research: the scope is 11 documents, and the missing facts (authority tiers, supersession) already exist in prose in other audit files — it needs assembly into the right schema, not data collection from scratch.
