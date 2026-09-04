# Source Registry — README

## What this folder contains

| File | Role |
|---|---|
| `source_registry.csv` | **The curated source registry.** One row per genuine physical source document (11 rows). This is the file to consult when you need to know what a source document is, where it came from, what authority tier it carries, and its checksum. |
| `file_inventory.csv` | A raw extraction/deduplication **audit trail**, not the registry. 1,803 rows: every original uploaded file plus everything recursively unpacked from nested ZIP archives (up to 8 levels deep). ~94% of its rows (1,696 of 1,803) are exact-duplicate copies of the same underlying content, tracked via `duplicate_group`/`exact_dup_count`. It remains in this folder unmodified as forensic/provenance history — **do not treat it as the source registry**, and do not delete or edit it. |
| `catalog86_merge_audit.csv` | Unrelated: a product-catalog name-matching audit, not part of the source registry schema. |
| `ocr_extracts/` | Contains one OCR text dump used to verify the compensation deck. Not a registry component. |

## Why `source_registry.csv` was created

A completed audit (`01_SOURCE_REGISTRY_AUDIT.md` at the repo root) found that no file literally named `source_registry.csv` existed, and that `file_inventory.csv` — while informally described elsewhere as filling that role — is structurally a raw dedup audit, not a curated per-document registry. Of the 1,803 rows in `file_inventory.csv`, only 11 correspond to genuine, distinct physical source documents on disk (confirmed by content hash, not filename). `source_registry.csv` was built to be that missing curated registry, scoped to exactly those 11 documents.

## Schema

`source_id, filename, source_type, source_url, date_obtained, document_date, version, authority, status, checksum, supersedes, notes`

- **`source_id`** — reuses the `file_id` value (e.g. `F00004`) already assigned to that document's row in `file_inventory.csv`. This convention was chosen instead of minting new IDs so the two files stay trivially joinable and so provenance back to the raw extraction audit is never ambiguous.
- **`source_type`** — derived from the `00_SOURCE_DOCUMENTS/` subfolder the file lives in (brochure, price_list, policy, compensation_deck, company_doc).
- **`source_url`** — empty for all 11 rows. These are local uploads, not URL-fetched content; no URL exists anywhere in the repo for any of them, so none was invented.
- **`date_obtained`** — empty for all 11 rows. No ingestion/upload date is recorded anywhere in the repo (`file_inventory.csv` has no date column at all), so this was left blank rather than guessed.
- **`document_date`** — populated only where a date is literally present in the filename (`India BV Price May 2026.pdf` → `2026-05`; `Dayjoy Product Brochure - English July2026...` → `2026-07`). Left empty for the other 9 documents, none of which carry a date in their filename or have one confirmed elsewhere in the repo.
- **`version`** — empty for all 11 rows; no version marker (e.g. "v2", "final") appears in any of the 11 filenames.
- **`authority`** — the 4-tier hierarchy from `08_GOVERNANCE/verification/dayjoy_source_verification_sop.md` ("Approved source hierarchy": 1 = price list/official policy/compliance document, 2 = approved brochure, 3 = FAQ corpus, 4 = internal structured dataset), applied per document. Price lists and policy PDFs are tier 1; brochures are tier 2; the two internal `.docx` architecture/generation documents are tier 4 as the closest fit (no tier in the SOP exactly describes an internal architecture document); the compensation deck is tier 1 because the SOP explicitly lists "joining rules" as tier-1 typical use and that deck is Dayjoy's official joining/compensation-structure document. No document in this set is tier 3 (FAQ corpus).
- **`status`** — `active` for all 11; none are known to be withdrawn or retired.
- **`checksum`** — the `sha256` value from `file_inventory.csv`, independently re-verified for this task by recomputing SHA-256 directly against each file on disk under `00_SOURCE_DOCUMENTS/`.
- **`supersedes`** — empty for all 11 rows. Per the audit, supersession in this repo happens at the derived-CSV level (e.g. `dayjoy_price_list_extracted_from_pdf.csv` being superseded by `dayjoy_price_list_may2026.csv` — see `PRICING_AUTHORITY_STATEMENT.md` in this folder), not between raw source PDFs. No raw-document-level supersession relationship exists to record.
- **`notes`** — one sentence on what the document is used for in this repo.

## Join keys — read this before writing any tooling against this registry

**Use `source_id` or `checksum` (`sha256`) to join. Do not join on `filename`.**

The audit that produced this registry found a real filename collision: `file_inventory.csv` contains two unrelated files both named `README.md` (`F00856` and `F01382`) with different SHA-256 hashes. A naive filename-only join against `00_SOURCE_DOCUMENTS/website_snapshots/README.md` matched the wrong one. Filenames in this repository are not guaranteed unique; `source_id` and `sha256` are.

## Scope note

`00_SOURCE_DOCUMENTS/website_snapshots/` contains 3 governance/template files (`README.md`, `WEBSITE_SNAPSHOT_POLICY.md`, `website_snapshot_log.csv`) that are intentionally out of scope for this registry — they document a website-snapshot source category that has never actually been populated (zero snapshots captured), per `WEBSITE_SNAPSHOT_POLICY.md`. They are not source documents and are not listed in `source_registry.csv`.
