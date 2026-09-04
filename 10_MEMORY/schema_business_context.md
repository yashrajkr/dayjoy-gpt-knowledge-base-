# Schema: Business Context Memory

Corresponds to `MEM-BIZ-001 — Business Memory` in `00_PROJECT_ARCHITECTURE/database_design/03_Database_Design 08_AI_MEMORY_SCHEMA.md`: a cached, per-distributor snapshot of business-system state (rank, BV/PV, team size) so an AI assistant can reference it without a live system call on every turn. **This is a cache of business-system output, not a source of truth** — the compensation rules themselves (ranks, BV matching ratios, incentive percentages) are canonical facts and live in `01_CANONICAL/compensation/`, never here.

This is a **schema definition only**. No real business context records exist in this repository.

## Fields

| Field | Type | Required | Description |
|---|---|---|---|
| `business_context_id` | string | yes | Unique ID. |
| `user_id` | string | yes | Foreign key to `schema_user_profile_memory.md` (must have `user_type` = `distributor` or `leader`). |
| `distributor_code` | string | yes | Matches `schema_user_profile_memory.md.distributor_code`. |
| `current_rank_label` | string | no | Snapshot of the distributor's current rank name, as returned by the business system at `snapshot_taken_at`. Must be labeled with its snapshot time; never presented as live/current without a freshness check. |
| `current_bv_cycle_total` | number | no | Snapshot of BV in the current matching cycle. Read-only cache. |
| `current_pv_cycle_total` | number | no | Snapshot of PV in the current cycle. Read-only cache. |
| `team_size_snapshot` | integer | no | Snapshot of downline count. |
| `activation_status` | enum(`active`,`inactive`,`pending`,`unknown`) | yes | Whether the distributor met the activation BV threshold for the current cycle, per the business system. |
| `snapshot_taken_at` | timestamp | yes | When this snapshot was pulled from the business system. |
| `snapshot_ttl_seconds` | integer | yes | How long this snapshot may be treated as fresh before the AI must refuse to answer rank/BV questions from cache and instead re-query or defer to a human/system lookup. |
| `data_source_system` | string | yes | Name of the backend system this was pulled from (e.g. `dayjoy-erp`), for audit traceability. |

## Example

```
EXAMPLE SCHEMA ROW — NOT REAL DATA
business_context_id: BIZCTX-EXAMPLE-00003
user_id: USR-EXAMPLE-00001
distributor_code: DJDIST-EXAMPLE-0001
current_rank_label: "Star Executive (example)"
current_bv_cycle_total: 2500
current_pv_cycle_total: 2500
team_size_snapshot: 4
activation_status: active
snapshot_taken_at: 2026-08-09T06:00:00Z
snapshot_ttl_seconds: 3600
data_source_system: "example-erp-system"
```

## Explicit non-goals

- This schema never stores the compensation *rules* (matching ratios, incentive percentages, rank thresholds) — only a per-distributor *snapshot of where they currently stand* against those rules. The rules themselves must always be read from `01_CANONICAL/compensation/dayjoy_compensation_plan.csv` and related canonical files.
