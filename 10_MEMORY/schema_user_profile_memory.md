# Schema: User Profile Memory

Corresponds to `MEM-UPROF-001 — User Profile Memory` in `00_PROJECT_ARCHITECTURE/database_design/03_Database_Design 08_AI_MEMORY_SCHEMA.md`. Persistent, low-churn attributes about one user (customer or distributor). This is the identity/attribute layer — preferences live in `schema_preferences.md`, business state lives in `schema_business_context.md`.

This is a **schema definition only**. No real user records exist in this repository.

## Fields

| Field | Type | Required | Description |
|---|---|---|---|
| `user_id` | string | yes | Internal unique identifier for the user. Never the same as a product_id/faq_id namespace. |
| `user_type` | enum(`customer`,`distributor`,`leader`,`prospect`) | yes | Matches the `audience` values used in `01_CANONICAL/faq/dayjoy_faq_canonical_v2.csv`, so retrieval logic can stay consistent across knowledge and memory. |
| `display_name` | string | no | First name or preferred name, as given by the user. |
| `preferred_language` | string | no | e.g. `hi`, `en`. Used to select response language, not to translate canonical facts. |
| `channel_of_record` | enum(`website`,`whatsapp`,`voice`,`app`,`internal`) | no | Primary channel this profile was created/last confirmed on. |
| `account_status` | enum(`active`,`inactive`,`unverified`,`unknown`) | yes | Self-reported/observed status only — this field must never be treated as authoritative for compensation eligibility; that is a canonical business-system fact, not memory. |
| `distributor_code` | string | no (required if `user_type` = `distributor`/`leader`) | Reference key only. The rank/BV/PV values themselves live in `schema_business_context.md`, sourced from the business system, not memory. |
| `region` | string | no | State/city, self-reported. |
| `consent_status` | enum(`granted`,`withdrawn`,`unknown`) | yes | Whether the user has consented to memory storage. If `withdrawn`, all other memory schemas for this `user_id` must be purged, not just this file. |
| `created_at` | timestamp | yes | When this profile record was first created. |
| `last_updated_at` | timestamp | yes | Last time any field in this record changed. |
| `last_verified_at` | timestamp | no | Last time the user re-confirmed these details (e.g., re-entered phone/email). |
| `source_of_truth_flag` | enum(`self_reported`,`system_verified`) | yes | Marks whether a field came from the user's own statement (lower trust) or a backend system (higher trust). Distinguishes this from canonical company data, which is always `system_verified` and lives outside this folder entirely. |

## Example

```
EXAMPLE SCHEMA ROW — NOT REAL DATA
user_id: USR-EXAMPLE-00001
user_type: distributor
display_name: "Test User (example only)"
preferred_language: hi
channel_of_record: whatsapp
account_status: active
distributor_code: DJDIST-EXAMPLE-0001
region: "Rajasthan (example)"
consent_status: granted
created_at: 2026-01-01T00:00:00Z
last_updated_at: 2026-08-01T00:00:00Z
last_verified_at: 2026-08-01T00:00:00Z
source_of_truth_flag: self_reported
```

## Explicit non-goals

- This schema does not store passwords, payment credentials, or government ID numbers.
- This schema does not store product prices, BV/PV rates, or compensation-plan rules — those are canonical facts (`01_CANONICAL/pricing/`, `01_CANONICAL/compensation/`) and must be looked up live, never cached here as if they were user-specific.
