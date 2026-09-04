# Dayjoy Golden Question Set (Test Questions)

`dayjoy_golden_questions.csv` — 169 question/expected-answer pairs, every one templated from and traceable to a specific canonical source file and record (see `source_file` + `source_reference` columns). None of the answers were invented — they were pulled directly from already-verified canonical data (product master, compensation plan, company profile, FAQ). This folder was renamed from `golden_questions/` to `test_questions/` to match the current repository structure; the file contents are unchanged.

## Coverage
- **product_pricing** (72) — MRP/DP/BV for a sample of products across every category
- **compensation_ranks** (34) — lifetime reward + BV target for all 17 rank clubs
- **product_identity** (24) — brand attribution
- **faq** (20) — sampled directly from the canonical FAQ set
- **compensation_eligibility** (9) — BV thresholds, T&C rules
- **compensation_loyalty** (5) — cashback wallet tiers
- **company** (5) — founder, legal name, contact, vision, manufacturer

## What this does and doesn't do
This is an eval set for **factual accuracy and retrieval correctness** — did the AI find and return the right sourced fact. It does **not** cover conversational quality, tone, multi-turn handling, or edge cases (ambiguous questions, out-of-scope requests, safety refusals) — those belong in `09_QA/regression/` and `09_QA/retrieval_tests/`, or need a separate eval set built with the Dayjoy support/product team.

## How to use
Run each `question` through the AI Assist, compare the response against `expected_answer`, and check it cites (or is at least consistent with) `source_file`/`source_reference`. A wrong answer here means either a retrieval failure or the AI ignoring/misreading the canonical source — both are launch blockers.
