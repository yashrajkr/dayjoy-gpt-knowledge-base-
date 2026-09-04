# Dayjoy Retrieval Strategy

## Purpose
This document defines how Dayjoy's AI assistant retrieves evidence before answering a question. It operationalizes the "Retrieval enforcement rules" and "Response enforcement rules" already defined in `08_GOVERNANCE/verification/dayjoy_source_verification_sop.md`, and it must be read together with that SOP and with `08_GOVERNANCE/answer_policy/ABSTAIN_AND_LABELING_POLICY.md`. It does not introduce new Dayjoy facts or override any existing governance rule — it describes, in one place, the pipeline that the existing rules imply.

## Core principle — structured lookup beats RAG text for exact facts
**Exact facts — price (MRP/DP), BV, PV, SKU, product code, pack size, rank/club thresholds, and any other numeric or identifier field — MUST be answered from a structured database lookup (`pricing_database`, `product_database`, `compensation_database`), never from free-text RAG chunk retrieval alone.**

This mirrors the SOP's numeric verification rule: "If a number is not explicitly present in the evidence, the answer must abstain or omit it" (`dayjoy_source_verification_sop.md`, "Numeric verification check"). RAG text chunks (`faq_pair`, `policy_section`) are for narrative, comparison, usage-summary, and consultation-style answers where a single structured field doesn't exist. When a RAG chunk and a structured record disagree on a number, the structured record wins and the discrepancy is logged as a data-quality issue, not silently resolved by picking whichever surfaced first.

## Pipeline: Intent → Retrieval → Reranking → Authoritative Context → Answer

```
User Question
     │
     ▼
[1] INTENT CLASSIFICATION
     - Maps to intent_category / required_tool / answer_source
       (see 03_AI_DATASETS/intents/dayjoy_intents_STRUCTURED.csv)
     - Detects entities: product_code, sku, product_name, symptom
     │
     ▼
[2] RETRIEVAL ENFORCEMENT ORDER (per dayjoy_source_verification_sop.md,
    "Retrieval enforcement rules" — this order is fixed, not learned)
     1. Exact product_code match       → pricing_database / product_database
     2. Exact SKU match                → pricing_database / product_database
     3. Exact product_name match       → product_database
     4. Exact policy phrase match      → faq_lookup / policy chunks
     5. Metadata filter                → approval_status, effective_from,
                                          role_scope, risk_level, retired_flag
     6. Semantic similarity (Keyword + Vector hybrid, "Search + Vector Search")
                                        → RAG chunk corpus (faq_pair, policy_section)
     7. Reranker                       → chunk_type, confidence, recency, query intent
     │
     ▼
[3] KEYWORD SEARCH + VECTOR SEARCH + METADATA FILTERING (parallel, step 5-6 above)
     - Keyword/BM25 search and vector/embedding search both run against the
       filtered candidate set — metadata filtering (approval_status=approved,
       current effective_from, matching role_scope, acceptable risk_level)
       ALWAYS runs before semantic ranking, per SOP: "Metadata filters must
       run before semantic retrieval to block draft, retired, unauthorized,
       or low-confidence chunks."
     │
     ▼
[4] RERANKING
     - Reranker combines chunk_type priority, confidence, freshness
       (effective_from), and query-intent match.
     - product_core / pricing_row chunks outrank faq_pair chunks for any
       question whose required_tool is pricing_database or product_database.
     │
     ▼
[5] AUTHORITATIVE CONTEXT ASSEMBLY
     - If required_tool is pricing_database / product_database /
       compensation_database → answer is built from the structured row,
       NOT from the reranked RAG text, even if a matching RAG chunk exists.
     - If required_tool is rag_retrieval / faq_lookup → answer is built
       from the top reranked chunk(s), each claim traceable to a chunk_id.
     - If required_tool is escalation / out_of_scope → no chunk is used to
       fabricate an answer; response follows ABSTAIN_AND_LABELING_POLICY.md.
     - If required_tool is web_search → results are routed through
       14_WEB/WEB_SEARCH_POLICY.md and are never merged into canonical
       context without a flagged conflict review.
     │
     ▼
[6] ANSWER GENERATION
     - Claim-level check: every numeric claim must appear verbatim in the
       structured record or cited chunk (SOP "Claim support check").
     - Disclaimer injection for UNVERIFIED health/dosage/business claims
       per ABSTAIN_AND_LABELING_POLICY.md.
     - Abstain if evidence is missing, low-confidence, retired, or
       CONFLICT_UNRESOLVED.
```

## Why keyword + vector + metadata filtering run together
Keyword search alone misses paraphrased questions; vector search alone can surface semantically-close but factually-wrong chunks (e.g. a different pack size of the same product family). Metadata filtering is not optional pre-processing — it is a gate. Per the SOP: chunks with `approval_status` other than `approved`, an `effective_from` in the future or superseded by a newer approved record, a `role_scope` that excludes the requester, or a `risk_level` requiring escalation must never reach the reranker. This repo's chunk corpus currently mixes `approved` (1,562 chunks) and `needs_review` (680 chunks) — see `04_RAG/chunks/dayjoy_rag_chunks_CANONICAL.csv`. Retrieval must filter `needs_review` chunks out of default customer-facing answers unless a human has upgraded them to `approved`.

## Routing table (summary)

| required_tool | Primary source | RAG allowed? |
|---|---|---|
| `pricing_database` | Structured pricing fields (MRP/DP/BV) | No — structured only |
| `product_database` | Structured product master fields | No — structured only |
| `compensation_database` | `01_CANONICAL/compensation/*` VERIFIED rows | No for VERIFIED rows; CONFLICT_UNRESOLVED rows abstain regardless of source |
| `faq_lookup` | Approved `faq_pair` / `policy_section` chunks | Yes |
| `rag_retrieval` | Approved `faq_pair` chunks (consultation, recommendation) | Yes, with disclaimer |
| `escalation` | None — routes to human/support | N/A |
| `out_of_scope` | None — polite redirect | N/A |
| `general_ai` | General reasoning, no Dayjoy KB fact | N/A |
| `web_search` | External web result, flagged per `14_WEB/WEB_SEARCH_POLICY.md` | N/A (never silently merged into canonical context) |

## Non-goals of this document
This document does not redefine chunk schemas, does not change approval workflows, and does not resolve the three CONFLICT_UNRESOLVED compensation fields (`01_CANONICAL/compensation/dayjoy_compensation_conflicts.csv`) — those remain governed by `ABSTAIN_AND_LABELING_POLICY.md` until a human confirms them.
