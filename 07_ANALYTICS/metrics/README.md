# Analytics Metrics — verification tier per file

Every file here is derived, not directly sourced. Per `08_GOVERNANCE/verification/CLAIM_VERIFICATION_STANDARD.md`, all of them are **INFERRED tier** — none are real business/sales telemetry. Do not present any of these as confirmed company data.

| File | What it actually is | Tier |
|---|---|---|
| `dayjoy_best_selling_products.csv` | Mention-frequency proxy across the internal text corpus. Not real sales data — Dayjoy has not supplied order/sales volume. | INFERRED |
| `dayjoy_high_margin_products.csv` | Derived from MRP/DP spread in the canonical product master. Reflects listed pricing math, not confirmed margin/cost accounting. | INFERRED |
| `dayjoy_popular_categories.csv` | Same mention-frequency proxy method as best-selling, applied at category level. | INFERRED |
| `dayjoy_seasonal_products.csv` | Keyword/co-occurrence-derived seasonality tagging, not observed sales seasonality. | INFERRED |
| `dayjoy_income_opportunities.csv` | Chunk co-occurrence between pricing/business content, not an earnings statement. | INFERRED |
| `dayjoy_business_insights.json` | Aggregate rollup of the above. | INFERRED |

## Required framing when these are used in an answer
Any answer touching these files must use the "based on internal analysis, not confirmed sales or earnings data" framing from `08_GOVERNANCE/answer_policy/ABSTAIN_AND_LABELING_POLICY.md`. If a user is clearly asking for real sales figures or guaranteed earnings, abstain rather than substitute one of these proxies.
