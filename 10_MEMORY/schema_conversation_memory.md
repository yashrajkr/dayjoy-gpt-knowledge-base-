# Schema: Conversation Memory

Corresponds to `MEM-CONV-001 — Conversation Memory` in `00_PROJECT_ARCHITECTURE/database_design/03_Database_Design 08_AI_MEMORY_SCHEMA.md`, and consumes/summarizes raw conversation logs described in `... 09_CONVERSATION_SCHEMA.md`. This schema is the *memory-layer summary* of a conversation, not the raw transcript store.

This is a **schema definition only**. No real conversation records exist in this repository.

## Fields

| Field | Type | Required | Description |
|---|---|---|---|
| `conversation_memory_id` | string | yes | Unique ID for this memory record. |
| `user_id` | string | yes | Foreign key to `schema_user_profile_memory.md`. |
| `channel` | enum(`website`,`whatsapp`,`voice`,`app`,`internal`) | yes | Matches conversation type catalog channel values in `09_CONVERSATION_SCHEMA.md`. |
| `conversation_type` | string | no | Free-text reference to a type from the `Conversation Type Catalog` (e.g. `CONV-PROD-001`, `CONV-DIST-SUP-001`) — kept as a loose reference, not a hard foreign key, since the catalog lives in project architecture docs, not this repo's runtime tables. |
| `started_at` / `ended_at` | timestamp | yes | Session boundaries. |
| `topic_summary` | string | yes | 1–3 sentence AI-generated summary of what was discussed. Must not restate canonical facts as if they were memory (e.g. do not store "user was told MRP is ₹59" as a fact to reuse — restate as "user asked about Black Salt Sprinkler pricing"). |
| `intent_tags` | list[string] | no | Detected intents (e.g. `product_inquiry`, `pricing_question`, `compensation_question`) — should align with `faq_category` values already used in `01_CANONICAL/faq/dayjoy_faq_canonical_v2.csv` where applicable, for consistent analytics. |
| `products_discussed` | list[string] | no | List of `product_id` values referenced (e.g. `DJP1080`), for context continuity only — not a substitute for re-querying the product master for current facts. |
| `sentiment` | enum(`positive`,`neutral`,`negative`,`unknown`) | no | Coarse sentiment signal for escalation routing. |
| `unresolved_flag` | boolean | yes | Whether the conversation ended without resolution (feeds `schema_recent_activity.md`). |
| `escalated_flag` | boolean | yes | Whether this conversation was escalated to a human. |
| `retention_expires_at` | timestamp | yes | When this memory record should be purged/anonymized per data retention policy. |

## Example

```
EXAMPLE SCHEMA ROW — NOT REAL DATA
conversation_memory_id: CONVMEM-EXAMPLE-00042
user_id: USR-EXAMPLE-00001
channel: whatsapp
conversation_type: CONV-PROD-001
started_at: 2026-08-05T10:15:00Z
ended_at: 2026-08-05T10:22:00Z
topic_summary: "User (example) asked about Golden Elixir usage and whether it can be combined with Super Food Capsule."
intent_tags: [product_inquiry, usage, comparison]
products_discussed: [DJP1080, DJP1105]
sentiment: neutral
unresolved_flag: false
escalated_flag: false
retention_expires_at: 2027-08-05T00:00:00Z
```

## Explicit non-goals

- This schema never stores the literal answer text given to the user as a re-usable "fact" — the answer must always be re-derived from canonical sources (FAQ/product master/policy) at response time, so that price or policy updates propagate immediately instead of being stuck in stale memory.
