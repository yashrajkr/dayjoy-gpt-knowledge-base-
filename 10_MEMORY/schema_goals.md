# Schema: Goals Memory

Corresponds to the `User Goals` memory object in `00_PROJECT_ARCHITECTURE/database_design/03_Database_Design 08_AI_MEMORY_SCHEMA.md` (Memory Object Catalog): long-term goals a user has stated or that the AI has reasonably inferred (e.g. "reach a specific rank", "reduce customer complaints", "grow team size"). Goals are directional context for the AI, not commitments made by Dayjoy.

This is a **schema definition only**. No real goal records exist in this repository.

## Fields

| Field | Type | Required | Description |
|---|---|---|---|
| `goal_id` | string | yes | Unique ID. |
| `user_id` | string | yes | Foreign key to `schema_user_profile_memory.md`. |
| `goal_type` | enum(`rank_advancement`,`income_target`,`team_growth`,`product_health_goal`,`service_resolution`,`other`) | yes | Coarse category. `product_health_goal` covers things like a customer wanting to address a specific wellness need — the AI may use this to prioritize which categories to surface (via `01_CANONICAL/products/dayjoy_recommendation_index_by_condition.csv`) but must still answer with real product/condition mappings, never invented ones. |
| `goal_description` | string | yes | Free text, in the user's own words where possible. |
| `target_value` | string | no | If quantifiable (e.g. a rank name, a BV number, a date) — must be stored as stated by the user, not validated against canonical rank tables at write time (validation happens at read/response time against `01_CANONICAL/compensation/dayjoy_plan_ranks_rewards_VERIFIED.csv`). |
| `status` | enum(`active`,`achieved`,`abandoned`,`stale`) | yes | Current status. |
| `created_at` | timestamp | yes | When the goal was recorded. |
| `target_date` | date | no | User-stated target date, if any. |
| `last_progress_check_at` | timestamp | no | Last time the AI or user reviewed progress. |
| `related_business_context_id` | string | no | Optional link to `schema_business_context.md` for goals tied to rank/BV. |

## Example

```
EXAMPLE SCHEMA ROW — NOT REAL DATA
goal_id: GOAL-EXAMPLE-00005
user_id: USR-EXAMPLE-00001
goal_type: rank_advancement
goal_description: "Example user wants to reach the next rank tier within 3 months."
target_value: "Example Rank Name"
status: active
created_at: 2026-07-01T00:00:00Z
target_date: 2026-11-01
last_progress_check_at: 2026-08-05T00:00:00Z
related_business_context_id: BIZCTX-EXAMPLE-00003
```

## Explicit non-goals

- A stored goal must never be treated as a guarantee of achievement or income — this stays consistent with the canonical `Income_Disclaimer_Dayjoy.pdf` in `01_CANONICAL/policies/`, which the AI must defer to whenever a goal-related question touches on expected earnings.
