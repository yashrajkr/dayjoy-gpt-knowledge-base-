# Dayjoy Source Verification SOP and Checklist

## Purpose
This SOP defines how Dayjoy should verify sources before content enters the canonical repository, the chunked RAG layer, or any customer-facing answer flow. The goal is to prevent hallucinated prices, unsupported compliance claims, unsafe medical answers, and answers based on retired or low-confidence records.[cite:605][cite:610]

## Scope
This SOP applies to raw PDFs, brochures, FAQ files, pricing sheets, policy documents, structured CSV/XLSX datasets, and any downstream chunked RAG exports used by the web app, mobile app, WhatsApp bot, internal copilot, or support desk.[cite:568][cite:577]

## Verification principles
- Every answerable fact must trace to an approved source chunk with immutable provenance metadata.[cite:568][cite:578]
- Verification must be separate from generation so the answering model does not approve its own evidence.[cite:605][cite:610]
- Metadata filters must run before semantic retrieval to block draft, retired, unauthorized, or low-confidence chunks.[cite:567][cite:575][cite:592]
- Every substantive answer claim must be supported by retrieved evidence at claim level, not just by document-level similarity.[cite:585][cite:588][cite:609]
- Numeric values such as MRP, DP, BV, dates, counts, and pack sizes require stricter checks because numbers are common hallucination points.[cite:604][cite:610]

## Approved source hierarchy
| Priority | Source type | Typical Dayjoy use | Verification rule |
|---|---|---|---|
| 1 | Price list / official policy / compliance document | MRP, DP, BV, joining rules, policy text | Must be current, approved, and exact-match verified.[cite:605] |
| 2 | Approved brochure | Product overview, pack size, general usage summary | Allowed only if version is approved and not contradicted by higher-priority source.[cite:568][cite:612] |
| 3 | FAQ corpus | Safe response patterns, disclaimers, support phrasing | Allowed only after chunk-level approval and policy screening.[cite:585][cite:611] |
| 4 | Internal structured dataset | Canonical master, safety classes, ranking rules | Must inherit provenance from approved sources and retain field-level confidence.[cite:571][cite:576] |

## Required metadata per chunk
Every chunk must include at least these fields so Dayjoy can verify provenance and enforce routing correctly: `chunk_id`, `document_id`, `source_page`, `product_code`, `sku`, `category`, `role_scope`, `risk_level`, `confidence`, `effective_from`, and `approval_status`.[cite:568][cite:571][cite:578]

Recommended additional fields are `section_path`, `source_hash`, `document_version`, `parser_version`, `embedding_model`, `retired_flag`, `reviewed_at`, and `authority_score` because these fields help with freshness checks, reproducibility, and post-incident audits.[cite:576][cite:577][cite:608]

## Ingestion SOP
### 1. Register the source
Assign a stable `document_id`, source type, source owner, effective date, version, and approval state before parsing. Do not ingest files directly into the RAG index without registry metadata.[cite:568][cite:576]

### 2. Parse with structure preservation
Extract title, section headings, page numbers, table rows, and list boundaries. Preserve table headers and page references because pricing and policy verification often fail when row context is lost.[cite:570][cite:577]

### 3. Chunk by meaning
Use structure-aware chunking by section, FAQ pair, policy clause, or table row. Avoid giant chunks with mixed topics and avoid tiny chunks that lose source context.[cite:569][cite:570][cite:594]

### 4. Attach immutable provenance
Copy parent metadata to every chunk and add chunk-specific position fields. Metadata must travel with the chunk during re-embedding, ranking, and answer generation.[cite:571][cite:578][cite:581]

### 5. Classify for safety and visibility
Assign `role_scope`, `risk_level`, and Dayjoy safety class at ingestion time. Do not let the generator infer safety at answer time from raw text alone.[cite:567][cite:575]

## Verification SOP
### 1. Source existence check
Confirm that every cited source exists in the registry and is accessible. Reject any answer that references a missing chunk, missing page, or stale document record.[cite:605][cite:611]

### 2. Metadata match check
Verify that document title, version, product code, SKU, and effective date match the source record. This prevents plausible-looking but wrong citations from entering the answer path.[cite:605][cite:608]

### 3. Claim support check
Break the proposed answer into atomic claims and score each claim as supported, contradicted, or not in evidence against the retrieved chunks. Only supported claims may appear in final answers.[cite:585][cite:588][cite:609]

### 4. Numeric verification check
Run a dedicated check for numbers in the answer, especially price, BV, DP, quantity, dosage, dates, and pack size. If a number is not explicitly present in the evidence, the answer must abstain or omit it.[cite:604][cite:610]

### 5. Freshness and retirement check
Reject evidence from retired, superseded, or draft content. If multiple approved sources disagree, prefer the latest effective approved document and flag the conflict for human review.[cite:605][cite:592][cite:612]

### 6. Confidence gate
Do not answer when all candidate chunks are below the confidence threshold or when the only matching value comes from unresolved fields. Low-confidence evidence should route to abstain or human escalation.[cite:590][cite:605]

## Retrieval enforcement rules
Dayjoy retrieval should follow this order: exact product code, exact SKU, exact product name, exact policy phrase, metadata filter, semantic similarity, and reranker. This sequence reduces confusion across similar product names and prevents semantic search from outranking explicit identifiers.[cite:579][cite:592]

Before semantic retrieval runs, apply filters for `approval_status`, `effective_from`, `role_scope`, `risk_level`, and `retired_flag`. This ensures unauthorized or outdated chunks never become answer candidates.[cite:567][cite:575][cite:592]

## Response enforcement rules
### Allowed directly
Price, DP, BV, category, pack size, availability if current, company facts, shipping/refund policy, joining basics, and brochure/training references may be answered directly when supported by approved chunks.[cite:610][cite:612]

### Allowed with citation and disclaimer
Product overview, general usage summary from approved brochure, and approved compliance statements may be answered only with explicit citation and the correct disclaimer language.[cite:611][cite:612]

### Block or escalate
Diagnosis, cure claims, disease-treatment claims, contraindication advice without approved regulatory source, and symptom-to-product medical guidance must be blocked or escalated.[cite:562][cite:558][cite:612]

## Dayjoy disclaimer policy
For regulated-product answers, the response should include a safety disclaimer when the topic touches health positioning, usage boundaries, or wellness interpretation. The disclaimer should clearly state that the content is informational and does not replace professional medical advice or treatment.[cite:558][cite:560][cite:563]

## QA gating before release
A release should not pass unless the QA suite confirms zero hallucinated prices, zero uncited compliance claims, zero unsafe medical claims, zero answers from retired documents, and zero answers from low-confidence unresolved fields. RAG evaluation should separate retrieval quality from generation quality and use claim-level verification in regression tests.[cite:585][cite:588][cite:590]

## Incident handling
If a bad citation, retired source, or unsupported claim is found after release, mark the source or chunk as invalid, remove or downgrade dependent chunks, regenerate affected datasets, and add the incident as a regression case in the QA suite. Source verification should be a continuous hardening loop, not a one-time setup step.[cite:605][cite:588]

## Operational checklist
### A. Source onboarding checklist
- Source has stable `document_id`.
- Source has version, owner, effective date, and approval state.
- Source is registered before chunking.
- Source type is mapped to approved hierarchy.
- Source hash or fingerprint is stored.[cite:568][cite:576][cite:608]

### B. Chunking checklist
- Chunk type is assigned correctly.
- Page number or section path is preserved.
- Table rows keep headers and units.
- Parent metadata is copied to every chunk.
- Role and safety metadata are present.[cite:570][cite:577][cite:581]

### C. Verification checklist
- Citation exists in registry.
- Metadata matches source record.
- Every claim is supported by retrieved evidence.
- Every numeric fact is explicitly present in evidence.
- Source is current and not retired.
- Chunk confidence is above threshold.[cite:604][cite:605][cite:609]

### D. Retrieval checklist
- Exact identifier matching runs before semantic search.
- Metadata filters run before ranking.
- Reranker uses confidence, freshness, and chunk type.
- Query trace stores retrieved chunk IDs and filters applied.[cite:579][cite:575][cite:588]

### E. Answer checklist
- Every factual claim has supporting citations.
- Compliance statements are cited and approved.
- Regulated answers include disclaimer when required.
- Unsafe medical content is blocked or escalated.
- Abstention triggers when evidence is insufficient.[cite:611][cite:590][cite:612]

## Suggested thresholds for Dayjoy
| Control | Suggested rule |
|---|---|
| Minimum answer support | All major claims supported; no unsupported claim allowed.[cite:609] |
| Numeric fact policy | 100% numeric verification required for price, DP, BV, dates, and pack size.[cite:604] |
| Source freshness | Only active approved sources with current effective date may answer.[cite:592] |
| Low-confidence handling | Abstain or escalate when final evidence set is low confidence.[cite:590][cite:605] |
| Citation policy | Every substantive answer claim must be grounded in retrieved chunks.[cite:611] |

## Implementation note
This SOP is complete enough to operationalize in Dayjoy’s repository, but it should be enforced in three places: ingestion pipeline, retrieval/ranking layer, and answer policy layer. If any one of those layers is missing, unsupported or outdated evidence can still leak into responses.[cite:567][cite:610][cite:612]
