# Web Search Policy

## Purpose
Defines when the Dayjoy AI assistant may use live web search, how web results must be labeled, and — most importantly — the rule that web results can never silently overwrite Dayjoy's own canonical data. This policy extends `08_GOVERNANCE/verification/dayjoy_source_verification_sop.md` and `08_GOVERNANCE/answer_policy/ABSTAIN_AND_LABELING_POLICY.md` to a source type those documents don't cover: the open web. It does not relax any rule in either document.

## The two knowledge domains

### OFFICIAL DAYJOY DATA → CANONICAL KNOWLEDGE
- **Where it lives:** `01_CANONICAL/`, `02_RELATIONSHIPS/`, `03_AI_DATASETS/`, `04_RAG/`, `05_SQL/`, `08_GOVERNANCE/`.
- **Characteristics:** Versioned, sourced (`document_id`, `confidence`, `approval_status`, `effective_from` fields), verified against original Dayjoy documents per the source verification SOP.
- **Answers:** "What does Dayjoy sell, charge, promise, or require?"
- **Authority:** Always wins over web search on any Dayjoy-specific fact, per the retrieval enforcement order in `dayjoy_source_verification_sop.md` (exact product code → exact SKU → exact product name → exact policy phrase → metadata filter → semantic similarity → reranker — none of these steps is "web search").

### CURRENT WEB → WEB SEARCH
- **Where it lives:** Not stored in this repository at all. Fetched live, at answer time, only when needed, and never persisted into `04_RAG/chunks/` or `03_AI_DATASETS/` as if it were a Dayjoy source.
- **Characteristics:** Unversioned, unverified against Dayjoy's own document set, time-bound (correct only as of the moment it was fetched).
- **Answers:** Things the canonical KB structurally cannot contain — live prices of things outside Dayjoy's catalog, current events, competitor moves, regulatory news, weather, or any other fact that changes faster than the KB's ingestion cycle.
- **Authority:** Never overrides a canonical fact. Used only to fill genuine gaps outside canonical scope, or to surface a possible conflict for human review.

## When web search may be triggered
Web search is the correct `required_tool` (see `03_AI_DATASETS/intents/dayjoy_intents_STRUCTURED.csv` and `dayjoy_intents_SUPPLEMENTARY_categories.csv`, category `web_search`) only when:
1. The question asks for information that is inherently time-sensitive and not something Dayjoy's own documents would contain (e.g. "gold price today," "current USD/INR rate," "is there a public holiday tomorrow").
2. The question asks about something outside Dayjoy's own catalog/policies but adjacent to it (e.g. competitor pricing, general regulatory news).
3. A canonical lookup has already been attempted and failed (per the retrieval enforcement order), and the question genuinely cannot be answered from `01_CANONICAL/`, `04_RAG/`, or `08_GOVERNANCE/`.

Web search must **not** be triggered as a shortcut around a structured lookup. If a product code, SKU, or product name is present, retrieval must follow `04_RAG/retrieval_rules/RETRIEVAL_STRATEGY.md` (structured database first) — web search is not a substitute for an incomplete canonical record.

## Labeling requirement
Every answer that incorporates a web result must:
1. State plainly that the information came from a live web search, not Dayjoy's own materials (e.g. "I don't have this in my knowledge base — here's what a web search found, as of today").
2. Never be written in a way that implies Dayjoy officially confirmed the fact.
3. Never be copied into `04_RAG/chunks/`, `04_RAG/metadata/`, or any `03_AI_DATASETS/` file as if it had passed the source verification SOP — it hasn't, and doing so would violate the SOP's "Verification must be separate from generation" principle.

## The CONFLICT_UNRESOLVED pattern
This repository already has a precedent for handling disagreement between sources without guessing: `01_CANONICAL/compensation/dayjoy_compensation_conflicts.csv` marks three compensation fields `CONFLICT_UNRESOLVED` where an old file and the authoritative PDF disagree, and `08_GOVERNANCE/answer_policy/ABSTAIN_AND_LABELING_POLICY.md` requires the AI to abstain and flag for human resolution rather than pick a side.

Web search results follow the identical pattern:

| Situation | Action |
|---|---|
| Web result agrees with canonical data | Canonical data is cited as the answer; the web result is not needed and is discarded, not stored. |
| Web result covers a gap canonical data doesn't address (e.g. current gold price) | Web result is presented, clearly labeled as web-sourced and time-bound. No canonical file is touched. |
| Web result **disagrees** with a canonical Dayjoy fact (e.g. a scraped page shows a different MRP, or claims Dayjoy holds a different FSSAI license number) | The canonical fact is used in the answer. The disagreement is logged as `CONFLICT_UNRESOLVED` (same label used in `dayjoy_compensation_conflicts.csv`) with both values, the web source, and a timestamp, and routed to human review. **The web value is never auto-applied to any canonical file.** |
| Web result disagrees with another web result | Neither is treated as authoritative; the assistant states uncertainty rather than picking one. |

## Standard disclaimer text for web-sourced answers
> "I don't have this in Dayjoy's own knowledge base, so this comes from a live web search as of [date] — please treat it as general external information, not an official Dayjoy fact."

## Standard disclaimer text for a detected conflict
> "I found web information that differs from what's in Dayjoy's own records. I'm going with Dayjoy's own data for this answer and flagging the difference for the team to review — I don't want to guess which one is right."

## Non-goals of this folder
- This folder does not fetch, cache, or store any actual web content. It defines policy only, per the instruction that no real web content should be added here.
- This folder does not change the canonical source hierarchy in `dayjoy_source_verification_sop.md` — the web is explicitly outside that hierarchy, not a fifth tier within it.
- This folder does not resolve the existing `CONFLICT_UNRESOLVED` compensation rows — those remain governed by `ABSTAIN_AND_LABELING_POLICY.md` until a human confirms them; this document only reuses the same conflict-handling *pattern* for a new source type (the web).

## Relationship to memory isolation
`10_MEMORY/memory_isolation_policy.md` establishes that user memory (profile, preferences, conversation history, business snapshots) can never override Company Knowledge. This document establishes the same rule for a second, independent external-information channel: live web search. Both channels may only ever supplement canonical knowledge or flag a conflict for review — neither may silently rewrite it. A system implementing this repository should treat "Company Knowledge always wins over Memory" (`10_MEMORY`) and "Company Knowledge always wins over Web Search, and disagreements are flagged, not auto-applied" (`14_WEB`) as the same principle applied to two different external-input channels.
