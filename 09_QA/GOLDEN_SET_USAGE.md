# Dayjoy Golden Set Usage Policy

## Combined golden set

The Dayjoy golden test set is the union of two files, both under `09_QA/test_questions/`:

1. `dayjoy_golden_questions.csv` — 169 original rows (GQ0001-GQ0169).
2. `dayjoy_golden_questions_v2_ADDITIONS.csv` — 51 new rows (GQ0170-GQ0220), added to close gaps in
   compensation-rank field coverage (business matching incentive, mentorship incentive, total income
   base, reward description — fields not exercised by the original set), pricing coverage for
   previously-untouched products, the 3 CONFLICT_UNRESOLVED compensation figures (must-abstain cases),
   regulated-product safety/contraindication behavior, and policy facts from the Income Disclaimer,
   Payment Gateway Policy, and Social Media Policy PDFs.

Combined size: **220 golden questions.** Treat the two files as one logical set — do not run one without
the other for gating decisions.

A separate, larger file — `09_QA/evaluation/evaluation_dataset.csv` (1,060 rows) — exists for broad
regression coverage across pricing, product, compensation, support, policy, ambiguous, adversarial, and
out-of-domain categories. The golden set is the small, hand-picked, high-confidence subset used as a
**hard gate**; the evaluation dataset is the larger set used for **trend monitoring** and broader
regression sweeps. Both draw only from verified rows in `01_CANONICAL/` and `08_GOVERNANCE/` — no
invented Dayjoy facts.

## Mandatory testing trigger

**Every model, prompt, RAG pipeline, database/schema, or router change must be evaluated against the
combined golden set (all 220 rows) before merging to production.** This includes:

- LLM model swaps or version upgrades (including provider-side silent model updates where detectable).
- System prompt or answer-policy prompt changes.
- Retrieval/RAG changes: chunking strategy, embedding model, vector index, re-ranking logic, top-k.
- Canonical data updates that touch pricing, compensation, product, FAQ, or policy source files.
- Intent router or tool-selection logic changes (e.g. changes to when `must_abstain` or
  `required_tool` routing fires).
- Any change to the abstain/escalation logic described in `ABSTAIN_AND_LABELING_POLICY.md`.

A change should not ship if it regresses any of the 6 metrics below versus the last approved baseline,
and in particular must not regress `abstention_quality` or `hallucination_rate` on the
`must_abstain=true` rows (compensation conflicts, adversarial cure/diagnosis/guaranteed-income cases).

## The 6 metrics

| Metric | One-line definition |
|---|---|
| `retrieval_accuracy` | Fraction of questions where the retrieval/RAG step surfaces the correct source chunk(s) (matching `expected_source` / `source_reference`) in the top-k results. |
| `answer_accuracy` | Fraction of questions where the generated answer matches `expected_answer` in substance (correct value/fact, not necessarily verbatim wording). |
| `citation_accuracy` | Fraction of `must_cite=true` answers that correctly cite the real source document/row backing the claim (no missing, wrong, or fabricated citation). |
| `hallucination_rate` | Fraction of answers that state a Dayjoy-specific fact (price, product claim, compensation figure) not traceable to any canonical row — target as close to 0% as possible. |
| `abstention_quality` | Fraction of `must_abstain=true` questions where the system correctly abstains/escalates (rather than guessing) AND fraction of `must_abstain=false` questions where the system does NOT wrongly abstain. |
| `latency` | Wall-clock time (p50/p95) from question submission to final answer, measured per category since retrieval-heavy categories (pricing, product) and generation-heavy categories (adversarial, ambiguous) have different expected baselines. |

## Notes on honesty of coverage

Some categories in the evaluation dataset are intentionally smaller than a round "200" target because
the underlying canonical data doesn't support more genuinely distinct, non-duplicated questions without
padding (e.g. only 17 verified compensation ranks exist, so distributor/compensation coverage tops out
around 84 rows in the evaluation dataset plus 15 in the golden additions — see the evaluation dataset's
category counts and this task's final report for the exact numbers and reasoning per category).
