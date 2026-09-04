# 14_WEB

## What this folder is
This folder defines the policy boundary between **Dayjoy's own canonical knowledge** (everything in `01_CANONICAL/`, `02_RELATIONSHIPS/`, `03_AI_DATASETS/`, `04_RAG/`, `08_GOVERNANCE/`) and **live web search results** that the AI assistant may need to fetch for questions the canonical KB cannot answer (current events, live prices of things Dayjoy doesn't sell, competitor information, regulatory news, etc.).

**This folder contains policy only.** No web page has been fetched, scraped, cached, or stored here, and none should be added by copying this policy pattern — see "Non-goals" below.

## Why this folder was added (justification for a new top-level folder)
The existing structure (`00`–`10`, `99`) has no location that separates "verified Dayjoy fact" from "thing the AI found on the live web just now." Without an explicit boundary:
- A web search result about a competitor's price, a news article, or a general fact could get pasted into a RAG chunk or an intent answer and be mistaken for a verified Dayjoy fact later.
- There is no documented rule for what happens when a web result *disagrees* with canonical data (e.g. a scraped review claiming a different price, or an outdated cached page claiming an old MRP).

`08_GOVERNANCE/verification/dayjoy_source_verification_sop.md` already defines an "Approved source hierarchy" (price list → brochure → FAQ corpus → internal structured dataset) — but that hierarchy has no rung for "the open web," because the web is not one of Dayjoy's own documents and cannot be pre-approved the way an uploaded PDF can. `14_WEB` fills that specific gap: it names the web as a distinct, always-external, always-flagged source class, consistent with the SOP's principle that "verification must be separate from generation" and its retrieval enforcement rule that exact identifiers and structured lookups outrank open-ended search.

This mirrors, on the web side, the same isolation principle `10_MEMORY/memory_isolation_policy.md` establishes on the user-memory side: **Company Knowledge always wins.** Memory isolation stops a user's conversation history from silently overriding a canonical fact; web isolation stops a live web result from doing the same thing. Together, `10_MEMORY` and `14_WEB` are the two places external-to-canonical information can enter the system, and both are bound by the same non-negotiable rule.

## Files in this folder
| File | Purpose |
|---|---|
| `WEB_SEARCH_POLICY.md` | The binding policy: when web search may be used, how results are labeled, and the `CONFLICT_UNRESOLVED` handling rule when a web result disagrees with canonical data. |

## The one rule that matters most
**Web search results must never silently overwrite canonical Dayjoy data.** A web result may only ever be presented as clearly-labeled, current-as-of-search-time external information. If it conflicts with anything in `01_CANONICAL/`, `04_RAG/`, or `08_GOVERNANCE/`, the conflict is flagged (`CONFLICT_UNRESOLVED`, the same pattern already used for the three open compensation-plan conflicts in `01_CANONICAL/compensation/dayjoy_compensation_conflicts.csv`) and routed to human review — never auto-applied. See `WEB_SEARCH_POLICY.md` for the full rule and worked examples.
