# Dayjoy Knowledge Base — File Inventory Summary

Generated: 2026-08-09. Full machine-readable inventory: `01_AUDIT/file_inventory.csv` (1,803 rows, one per file record — every original file plus everything found inside every ZIP, including ZIPs nested inside ZIPs, up to 8 levels deep). Columns: `file_id, filename, extracted_path, provenance_chain, depth, size, file_type, sha256, duplicate_group, exact_dup_count`.

## Source folder as received

| Item | Detail |
|---|---|
| Top-level loose files | 2 `.docx` (architecture/master KB docs, ~3MB each), 4 `.pdf` (GrowthX deck, product brochure, recommendation chart, ~14MB/7.8MB/4MB), 3 `.zip` (`artifacts-1of3/2of3/3of3.zip`, 85MB/100MB/17.5MB) |
| `some updated file/` folder | 208 files: 197 CSVs (170 of them per-product FAQ files in a `Dayjoy_All_Products_FAQs/` subfolder), 3 zips, 5 PDFs, 1 xlsx — dated **2026-08-09 (today)**, the most recent activity in the whole KB |
| Total on-disk size | 240 MB, 216 files, before unpacking anything |

## After full recursive unpacking

| Metric | Value |
|---|---|
| Total file records | 1,803 |
| Files with unique content (by SHA-256) | **440** |
| Exact duplicate records | 1,696 (94%) — see `DUPLICATE_REPORT.md` |
| Zip files found (top-level + nested inside other zips) | 20+ |

## Unique-content files by category (440 total)

| Category | Count | Notes |
|---|---|---|
| FAQ | 179 | 170 per-product files (genuinely unique, one per SKU) + ~9 combined/summary files |
| Architecture/planning docs | 32 | Engineering docs for building Dayjoy AI Assist — system, database, API, deployment, security architecture + "Project_Context" set |
| Other (unclassified by keyword) | 82 | Mostly more architecture/project docs, plus knowledge-base exports, search config, business insights — see `MISSING_KNOWLEDGE.md` for the notable ones |
| Gap/QA | 22 | Two pipelines' gap registers, QA test sheets, audit reports — see Duplicate/Outdated reports for lineage |
| RAG chunks/corpus | 22 | Two unreconciled pipelines (2,242-row governance set vs. 4,000-row Q&A set), each exported in 5 formats (csv/json/sql/xlsx/md) |
| Intent dataset | 17 | Two unreconciled pipelines (1,527 rows vs. 4,000 rows) |
| SQL/DB | 15 | Schema, seed data, Postgres-ready bundle |
| Product master | 13 | Multiple phases; canonical candidate still pending reconciliation (2 conflicting "final" versions) |
| Company | 8 | Mostly thin structured CSVs + one solid 14KB narrative doc |
| Policy/legal | 8 | FSSAI license, payment gateway policy, social media policy, income disclaimer, recommendation chart PDF |
| AI training/conversation | 7 | ShareGPT-format memory examples |
| Pricing | 7 | May 2026 price list (multi-format) + BV price PDF |
| Recommendation chart | 7 | Health-condition → product mapping, multiple versions |
| Source docs | 5 | Brochure, GrowthX deck, ecosystem docx |
| Taxonomy | 5 | Brands, categories, sub-brands |
| Relationships | 4 | Product-to-product relationship data + review file |
| Image metadata | 4 | **Describes images that do not exist in the KB** — see Missing Knowledge report |
| Compensation | 3 | Very thin — see Missing Knowledge report |

## What's genuinely new/useful that a casual look would miss

- A complete internal engineering architecture doc set (32 files covering system/database/API/security/deployment architecture) was buried 3 zip-levels deep inside `artifacts-1of3.zip > artifacts.zip`. This is planning documentation for the AI Assist platform itself, not customer knowledge — worth surfacing into its own top-level folder rather than losing it in archive.
- The `some updated file/` folder, despite its throwaway name, contains the **most recent, most-refined versions** of several canonical candidates (`dayjoy-canonical-product-master-final`, `dayjoy-rag-chunks-final`, `dayjoy-intent-master-final`) — it is not a dumping ground, it's today's work-in-progress output.

Full per-file detail, provenance chains, and duplicate group IDs: see `01_AUDIT/file_inventory.csv`.
