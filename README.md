# Dayjoy Knowledge Base

The governed Dayjoy Knowledge Layer: source documents, canonical facts, relationships, AI-ready datasets, the RAG data layer, database schema, images, analytics, governance controls, and QA — organized so an AI assistant can retrieve reliably and abstain honestly when it shouldn't answer.

**Current version: 2.1.0-audited.** This repository has been through a strict Phase 1-3 production-readiness audit (Source Registry, Product Master, Pricing Master) plus cross-data validation. Start with `05_PRODUCTION_READINESS_REPORT.md` for the verdict on each phase, `06_REMAINING_GAPS.csv` for every open item and whether it needs a human decision, and `DATA_QUALITY_REPORT.md` for a metrics-first view. The individual phase audits (`01_SOURCE_REGISTRY_AUDIT.md`, `02_PRODUCT_MASTER_AUDIT.md`, `03_PRICING_MASTER_AUDIT.md`, `04_CROSS_DATA_VALIDATION.md`) have the full evidence trail. **Phase 4 (new AI features) has not started — this repository is paused for your review of the audit results, per your instruction.**

```
                 DAYJOY KNOWLEDGE REPOSITORY
                           │
          ┌────────────────┼────────────────┐
          │                │                │
     SOURCE LAYER      CANONICAL LAYER   GOVERNANCE
   (00_SOURCE_DOCS)     (01_CANONICAL)   (08_GOVERNANCE)
          │                │                │
          └──────────┬─────┘
                     ▼
               RAG DATA LAYER (04_RAG)
                     │
          ┌──────────┼──────────┐
          ▼          ▼          ▼
       Chunks     Metadata   Embeddings
     (built)     (built)    (NOT built — gated,
                              see 04_RAG/embeddings_manifest/)
                     ▼
                 AI BRAIN  (not part of this repo —
                     │      this repo is what it reads from)
       ┌─────────────┼─────────────┐
       ▼             ▼             ▼
   Dayjoy RAG    Business DB    Web Search
       │             │             │
       └─────────────┼─────────────┘
                     ▼
               PERSONALIZED AI
```

This repository is the top three boxes plus the RAG data layer. The "AI Brain" and everything below it is the application that will consume this repository — it is not built here, but the answer-policy and abstain rules this repository ships (`08_GOVERNANCE/answer_policy/`) are written for that layer to enforce.

## Lineage — this is not a fresh build

This repository was assembled by reorganizing and extending `Dayjoy-KB-FINAL` (the prior working knowledge base, version `1.1.0-verified`), not by re-auditing or regenerating data from scratch. `Dayjoy-KB-FINAL` was itself built from a full forensic audit of 216 raw files (1,803 file records once nested zips were unpacked, 440 with unique content) — that audit trail is preserved at `08_GOVERNANCE/audit/`. Nothing was deleted at any stage; superseded material lives in `99_ARCHIVE/`.

What changed in this pass:
1. **Restructure** — files were moved/renamed into the folder layout below. No canonical dataset was regenerated; where content differs from `Dayjoy-KB-FINAL`, it's because a bug was fixed (see CHANGELOG) or a new governance document was added, never because data was reprocessed.
2. **New governance layer** — verification tiers (VERIFIED / UNVERIFIED / INFERRED), an explicit abstain policy for health, dosage, compensation, "best-selling," and income claims, and a website-as-a-live-source policy. See "Governance" below.
3. **Bug fix** — the product-image de-duplication step in `Dayjoy-KB-FINAL` had wrongly dropped 16 legitimate multi-angle product photos along with 92 real accidental duplicates. Fixed here using content-hash comparison instead of filename-pattern matching. See CHANGELOG.

## Folder guide

| Folder | Contents |
|---|---|
| `00_SOURCE_DOCUMENTS/` | Raw inputs, organized by type: brochures, price lists, policies, compensation deck, company docs, and website snapshots (empty — see policy inside). Nothing in this repo is treated as true unless it traces back to something here. |
| `01_CANONICAL/` | The actual knowledge: products, pricing, company, compensation, training, policies, faq, support. This is what `04_RAG/` is built from. |
| `02_RELATIONSHIPS/` | Product-to-product and product-to-condition relationships. `category_graph/` is a known gap (see its README). |
| `03_AI_DATASETS/` | Intents, conversations, customer journeys — data shaped for AI training/eval rather than source-of-truth lookup. |
| `04_RAG/` | Chunks + metadata are built. Embeddings are **not** generated yet — gated on resolving the open conflicts listed in `04_RAG/embeddings_manifest/README.md`. |
| `05_SQL/` | Database schema, migrations, seed data, validation reports. |
| `06_IMAGES/` | 126 real product photos covering 108 of 170 SKUs, plus placement/metadata records. 62 SKUs have no photo — no source image existed for them. |
| `07_ANALYTICS/` | Business insight exports. Every file here is INFERRED tier (derived/proxy), not real sales or earnings data — see `07_ANALYTICS/metrics/README.md`. |
| `08_GOVERNANCE/` | Source registry, verification standard, safety classes, answer policy (including the new abstain rules), and the historical audit trail. Read this folder before wiring up anything customer-facing. |
| `09_QA/` | Golden question set (169 sourced Q&A pairs, in `test_questions/`), regression tests, retrieval tests. `expected_answers/` is a known gap. |
| `99_ARCHIVE/` | Everything superseded, with a disposition record. Nothing physically deleted. |
| `00_PROJECT_ARCHITECTURE/` | Engineering architecture docs for building the Dayjoy AI Assist application itself (system/database/API/security architecture, personas, tech stack). Not customer-facing knowledge — kept at root since it doesn't fit the numbered knowledge tree, same as in `Dayjoy-KB-FINAL`. |

## Governance — read this before building retrieval or generation on top of this repo

Three documents matter most:

1. **`08_GOVERNANCE/verification/CLAIM_VERIFICATION_STANDARD.md`** — defines VERIFIED / UNVERIFIED / INFERRED and maps every major dataset in this repo to a tier. Flags a real inconsistency in the product master (`verification_status` says "approved" on every row while `content_risk_level` says "high" on every row) and states which one governs.
2. **`08_GOVERNANCE/answer_policy/ABSTAIN_AND_LABELING_POLICY.md`** — the operative rule for the five claim categories that must never be stated as flat fact: health benefits, dosage, compensation figures, "best-selling" claims, and business/income claims. Includes exact disclaimer text and abstain triggers.
3. **`00_SOURCE_DOCUMENTS/website_snapshots/WEBSITE_SNAPSHOT_POLICY.md`** — the Dayjoy public website carries company info, products, FAQs, support, and compensation material, and it changes without notice. This policy treats it as a versioned, re-verified source, never as a trusted live feed and never as the sole source of truth for any fact. No website content has been captured into this repository yet — nothing was invented to fill that gap.

## Known open items (do not build customer-facing answers on these yet)

- 3 compensation figures are `CONFLICT_UNRESOLVED` between an old unsourced file and the OCR-verified GrowthX PDF (`01_CANONICAL/compensation/dayjoy_compensation_conflicts.csv`).
- 1 of 86 catalog items ("Neem & Aloevera Herbal Soap") has no confident match to the canonical 170-SKU master.
- 62 of 170 products have no product photo.
- No website snapshot has been captured yet.
- Embeddings are not generated (by design — see `04_RAG/embeddings_manifest/README.md`).

Full detail and a completed/blocked/conflicting/remaining breakdown: `PRODUCTION_READINESS_REPORT.md`.
