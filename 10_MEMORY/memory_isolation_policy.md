# Memory Isolation Policy

## Purpose

Define hard boundaries between the different kinds of information a Dayjoy AI assistant draws on, so that user-specific memory can never silently override or contaminate verified company facts. This policy governs every schema file in this folder and any runtime memory store built from them.

## The 4 memory domains

### 1. Company Knowledge (canonical, authoritative)

- **Where it lives:** `01_CANONICAL/`, `02_RELATIONSHIPS/`, `08_GOVERNANCE/`, `04_RAG/`, `05_SQL/` — products, pricing, FAQs, compensation plan, policies, safety classes.
- **Who can write it:** Only the governed content-update process (source-document extraction, verification, approval status). Never an AI assistant at conversation time. Never a memory-write operation.
- **Characteristics:** Slow-changing, versioned, sourced (`source_document_id`, `confidence`, `approval_status` fields present throughout), same for every user.
- **Answers the question:** "What is true about Dayjoy, its products, prices, and policies?"

### 2. User Memory (this folder's schemas: profile, preferences, goals, long-term memory)

- **Where it lives:** Runtime store built from `schema_user_profile_memory.md`, `schema_preferences.md`, `schema_goals.md`, `schema_long_term_memory.md`.
- **Who can write it:** The AI system, based on what a specific user says or does, scoped strictly to that `user_id`.
- **Characteristics:** User-specific, consent-gated, can be corrected or deleted by the user, never shared across users.
- **Answers the question:** "What do we know about this specific person's preferences, history, and goals?"

### 3. Business Data (per-distributor operational snapshots)

- **Where it lives:** Runtime store built from `schema_business_context.md`, sourced from backend business/ERP systems.
- **Who can write it:** Only automated sync jobs pulling from the authoritative business system — never inferred or asserted by the AI from conversation alone.
- **Characteristics:** Time-stamped snapshots with a TTL; always secondary to the live business system, never treated as more current than its `snapshot_taken_at` + `snapshot_ttl_seconds` window.
- **Answers the question:** "Where does this specific distributor currently stand against the (canonical) compensation rules?"

### 4. Conversation History (session and interaction logs)

- **Where it lives:** Runtime store built from `schema_conversation_memory.md` and `schema_recent_activity.md`.
- **Who can write it:** The AI system, automatically, as conversations happen.
- **Characteristics:** Short-to-medium lived, summarized over time, feeds User Memory (domain 2) once distilled, but is not itself long-term truth.
- **Answers the question:** "What has this user said/done recently, and is there anything still open?"

## The rule: Company Knowledge always wins

When there is any conflict, ambiguity, or overlap between what Company Knowledge says and what any memory domain (User Memory, Business Data, or Conversation History) suggests, **Company Knowledge always wins for factual questions.**

Concretely:

1. If a memory record appears to state a product price, ingredient, policy term, or compensation rule that differs from the canonical source, the canonical source is used in the response and the conflicting memory record is flagged `review_required: true` (see `schema_long_term_memory.md`) rather than silently trusted.
2. Memory may only be used to decide **how** to respond (tone, language, which category to lead with, whether to proactively follow up on an open thread) — never **what the facts are**.
3. A cached `schema_business_context.md` snapshot may be shown with its snapshot timestamp, but if the user asks a question requiring current accuracy (e.g. "what's my rank right now") and the snapshot's TTL has expired, the AI must say so and avoid presenting stale data as current, rather than answer confidently from memory.
4. No memory record, regardless of domain, may be used to answer a question about Dayjoy the company, its products, its pricing, or its policies in place of the canonical sources in `01_CANONICAL/`, `02_RELATIONSHIPS/`, or `08_GOVERNANCE/`.
5. If User Memory and Conversation History disagree with each other (e.g. a stated preference contradicts recent behavior), prefer the more recent, more explicit signal, and never let either override Company Knowledge or Business Data.

## Isolation enforcement

- Every schema in this folder is scoped to a single `user_id` — no cross-user aggregation is permitted without explicit anonymization for analytics purposes (see `Semantic Memory` / `AI Feedback` handling in `00_PROJECT_ARCHITECTURE/database_design/03_Database_Design 08_AI_MEMORY_SCHEMA.md`).
- Withdrawn consent (`schema_user_profile_memory.md.consent_status = withdrawn`) purges all 4 memory-domain records for that `user_id`; it has no effect on Company Knowledge (which was never user-specific to begin with).
- No schema in this folder stores a duplicated copy of canonical content (prices, ingredients, policy text) — every field that references such content does so by ID (`product_id`, `faq_id`, category slug), forcing a live lookup rather than a stale cached copy.
