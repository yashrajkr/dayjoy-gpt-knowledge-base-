# Schema: Recent Activity Memory

Corresponds to the `Pending Tasks` memory object and the short-lived "Working/Session Memory" types (`MEM-WORK-001`, `MEM-SESSION-001`, `MEM-CTX-001`) in `00_PROJECT_ARCHITECTURE/database_design/03_Database_Design 08_AI_MEMORY_SCHEMA.md`. This is the shortest-lived memory layer: a rolling log of what just happened, used to keep the current session coherent. It is expected to churn constantly and expire quickly.

This is a **schema definition only**. No real activity records exist in this repository.

## Fields

| Field | Type | Required | Description |
|---|---|---|---|
| `activity_id` | string | yes | Unique ID. |
| `user_id` | string | yes | Foreign key to `schema_user_profile_memory.md`. |
| `activity_type` | enum(`viewed_product`,`asked_faq`,`compared_products`,`requested_callback`,`abandoned_task`,`other`) | yes | What kind of event this is. |
| `reference_id` | string | no | The `product_id`/`faq_id`/`conversation_memory_id` this activity relates to, so the AI can pull live canonical detail rather than caching it. |
| `activity_detail` | string | no | Short free-text description (e.g. "asked about Golden Elixir dosage, did not get a follow-up answer"). |
| `occurred_at` | timestamp | yes | When this happened. |
| `pending_followup` | boolean | yes | Whether this activity implies an open loop the AI should proactively address next time (e.g. an unanswered question, an abandoned comparison). |
| `expires_at` | timestamp | yes | This layer should expire fast (hours to a few days) — items worth keeping longer should be promoted into `schema_long_term_memory.md` or `schema_goals.md` by a summarization process, not left here indefinitely. |

## Example

```
EXAMPLE SCHEMA ROW — NOT REAL DATA
activity_id: ACT-EXAMPLE-00099
user_id: USR-EXAMPLE-00001
activity_type: compared_products
reference_id: DJP1080
activity_detail: "Example user compared Golden Elixir vs Super Food Capsule, did not complete the conversation."
occurred_at: 2026-08-09T09:40:00Z
pending_followup: true
expires_at: 2026-08-12T09:40:00Z
```

## Explicit non-goals

- Recent activity is a pointer/log layer only. It must never store a duplicated copy of the answer content itself (price, ingredients, policy text) — only the fact that the topic came up, plus a reference ID to re-fetch the canonical content live.
