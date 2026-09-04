# Schema: Long-Term Memory

Corresponds to `MEM-LT-001 — Long-Term Memory` in `00_PROJECT_ARCHITECTURE/database_design/03_Database_Design 08_AI_MEMORY_SCHEMA.md`: persistent, distilled facts *about a user's relationship with Dayjoy* that outlive any single conversation. This is where `schema_conversation_memory.md` records get consolidated once they age out of active session context.

This is a **schema definition only**. No real long-term memory records exist in this repository.

## Fields

| Field | Type | Required | Description |
|---|---|---|---|
| `long_term_memory_id` | string | yes | Unique ID. |
| `user_id` | string | yes | Foreign key to `schema_user_profile_memory.md`. |
| `memory_category` | enum(`support_history`,`product_interest`,`relationship_note`,`recurring_question`,`escalation_history`) | yes | High-level bucket, aligned with the `Memory Object Catalog` in `08_AI_MEMORY_SCHEMA.md` (e.g. `Support History`, `Product Interests`). |
| `summary_text` | string | yes | Distilled, human-readable statement (e.g. "Frequently asks about respiratory-support products; previously escalated a delivery-timing complaint in [example month]"). |
| `supporting_conversation_ids` | list[string] | no | Links back to `conversation_memory_id` values this summary was distilled from. |
| `confidence` | enum(`low`,`medium`,`high`) | yes | Mirrors the `confidence` convention already used in `01_CANONICAL/faq/dayjoy_faq_canonical_v2.csv`, so the whole platform uses one confidence vocabulary. |
| `first_observed_at` | timestamp | yes | When this pattern/fact was first noted. |
| `last_reinforced_at` | timestamp | yes | Last conversation that supported this memory. |
| `decay_status` | enum(`active`,`stale`,`archived`) | yes | `stale` after N months without reinforcement (per retention policy); `archived` items are excluded from live retrieval but kept for audit. |
| `review_required` | boolean | yes | Set true if the memory might conflict with a canonical fact and needs human review before being surfaced again. |

## Example

```
EXAMPLE SCHEMA ROW — NOT REAL DATA
long_term_memory_id: LTM-EXAMPLE-00007
user_id: USR-EXAMPLE-00001
memory_category: product_interest
summary_text: "Example user has asked about HEALTH CARE category products (respiratory support) in 3 separate conversations over 2 months."
supporting_conversation_ids: [CONVMEM-EXAMPLE-00042, CONVMEM-EXAMPLE-00051]
confidence: medium
first_observed_at: 2026-06-01T00:00:00Z
last_reinforced_at: 2026-08-05T00:00:00Z
decay_status: active
review_required: false
```

## Explicit non-goals

- Long-term memory never stores a cached copy of a product's price, ingredient list, or compensation rule "because the user asked about it often." Frequency-of-interest is memory; the underlying fact is always re-fetched from `01_CANONICAL/`.
