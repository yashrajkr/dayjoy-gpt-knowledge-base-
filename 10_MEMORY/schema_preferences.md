# Schema: Preferences Memory

Corresponds to `MEM-PREF-001 — Preference Memory` in `00_PROJECT_ARCHITECTURE/database_design/03_Database_Design 08_AI_MEMORY_SCHEMA.md`: explicit and inferred preferences that shape *how* the AI communicates, not *what* it says. Preferences never override canonical facts — they only affect tone, channel, and format.

This is a **schema definition only**. No real preference records exist in this repository.

## Fields

| Field | Type | Required | Description |
|---|---|---|---|
| `preference_id` | string | yes | Unique ID. |
| `user_id` | string | yes | Foreign key to `schema_user_profile_memory.md`. |
| `preferred_language` | string | no | Overrides/refines `schema_user_profile_memory.md.preferred_language` if it has changed since profile creation. |
| `preferred_channel` | enum(`website`,`whatsapp`,`voice`,`app`) | no | Channel the user prefers to be contacted on. |
| `communication_tone` | enum(`formal`,`informal`,`no_preference`) | no | Formal/informal tone preference, mirrors the object of the same name in `08_AI_MEMORY_SCHEMA.md`. |
| `notification_opt_in` | boolean | no | Whether the user has opted in to proactive messages (offers, reminders). Must be consistent with consent records, not just inferred. |
| `product_category_interests` | list[string] | no | Category slugs from `01_CANONICAL/company/dayjoy_categories.csv` (e.g. `health-care`, `skin-care`) the user has shown interest in — used only to prioritize which categories to surface first, never to restrict what canonical information is available. |
| `content_detail_level` | enum(`brief`,`detailed`) | no | Whether the user tends to prefer short answers or full detail. |
| `source` | enum(`explicit`,`inferred`) | yes | Whether the user directly stated this preference or the AI inferred it from behavior. Inferred preferences should be weighted lower and re-confirmed periodically. |
| `last_updated_at` | timestamp | yes | Last change to this preference record. |

## Example

```
EXAMPLE SCHEMA ROW — NOT REAL DATA
preference_id: PREF-EXAMPLE-00011
user_id: USR-EXAMPLE-00001
preferred_language: hi
preferred_channel: whatsapp
communication_tone: informal
notification_opt_in: true
product_category_interests: [health-care, food-products]
content_detail_level: brief
source: inferred
last_updated_at: 2026-08-01T00:00:00Z
```

## Explicit non-goals

- Preferences never gate or filter *factual* answers (e.g. a "brief" preference must not cause the AI to omit a required safety disclaimer from `08_GOVERNANCE/safety/dayjoy_product_safety_classes.csv`).
