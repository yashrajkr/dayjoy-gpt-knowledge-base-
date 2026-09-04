# 10_MEMORY

## What this folder is

This folder holds **AI memory schemas** — field-level definitions for how a Dayjoy AI assistant should structure short-term and long-term memory about a *user, conversation, or business context*. It is **schema-only**: there is no real user data anywhere in this folder, and none should ever be committed here. Every example row in every schema file is explicitly labeled `EXAMPLE SCHEMA ROW — NOT REAL DATA` and uses obviously fictitious values (fake names, fake IDs, fake numbers).

## Why this folder was added

The repository already contains a narrative description of the intended memory architecture in `00_PROJECT_ARCHITECTURE/database_design/03_Database_Design 08_AI_MEMORY_SCHEMA.md` (memory type catalog, memory objects, lifecycle) and `... 09_CONVERSATION_SCHEMA.md` (conversation structure). Those documents describe *why* memory exists and *what categories* of memory the platform intends to support, but there was no top-level location holding the concrete, field-by-field schema definitions as standalone reference artifacts that a builder/AI engineer could implement directly against. `10_MEMORY` fills that specific gap, using the next available top-level number after the existing `00`–`09` folders. It does not duplicate or contradict `00_PROJECT_ARCHITECTURE` — it operationalizes the subset of that architecture (`User Profile Memory`, `Conversation Memory`, `Long-Term Memory`, `Business Memory`, `Preference Memory`, `User Goals`, `Pending Tasks`/recent activity) into concrete schemas, and stays consistent with that document's terminology.

## Files in this folder

| File | Purpose |
|---|---|
| `schema_user_profile_memory.md` | Persistent attributes about a single user (customer or distributor) — identity, role, contact, verified account facts. |
| `schema_conversation_memory.md` | Structured record/summary of a conversation or conversation turn. |
| `schema_long_term_memory.md` | Durable facts and summaries retained across many sessions (beyond a single conversation). |
| `schema_business_context.md` | Business-state facts about a distributor (rank, activation status, team size) — never product/company facts. |
| `schema_preferences.md` | Explicit and inferred preferences (language, channel, tone, notification settings). |
| `schema_goals.md` | User-stated or inferred goals (e.g., "reach a rank", "reduce complaints") and their status. |
| `schema_recent_activity.md` | Short-lived log of recent actions/events (last order viewed, last topic discussed, pending follow-ups). |
| `memory_isolation_policy.md` | The 4 memory domains and the rule that company knowledge always wins on factual questions. |

## The one rule that matters most

**Memory must never overwrite canonical company facts.** Product prices, ingredients, compensation-plan rules, policies, and any other fact that lives in `01_CANONICAL/`, `02_RELATIONSHIPS/`, or `08_GOVERNANCE/` is the single source of truth. Memory (this folder's schemas, and any future runtime memory store built from them) may only store information *about* a specific user, conversation, or business relationship — it must never be used to answer "what does Dayjoy sell / charge / promise," and a memory record that appears to contradict a canonical fact must always lose to the canonical fact. See `memory_isolation_policy.md` for the full rule.
