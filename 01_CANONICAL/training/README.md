# Distributor Training Curriculum

`training_curriculum.csv` — 30 lessons across Beginner/Intermediate/Advanced, covering Dayjoy basics,
product knowledge, ethics/compliance, and generic sales/leadership methodology.

## What's real vs. what's a placeholder

The only genuine Dayjoy-specific training-curriculum source found anywhere in this repo is a list of
**program names** on page 54 of the GrowthX Plan Presentation OCR ("DAYJOY DRIVE"), tiered by
`Must Learn for All Distributors` / `Ruby Director & Above` / `Emerald & Above`. No actual lesson
content, scripts, slide decks, or certification materials for those named programs exist in this repo
(confirmed by `distributor_system_narrative_UNSTRUCTURED.md` section 20.4, which explicitly lists
leadership training, certification programs, and a detailed sales curriculum as **UNKNOWN**).

Because of that:

- **22 lessons are `content_provenance = DAYJOY_SOURCED`.** Where real, verifiable Dayjoy content exists
  (company facts, the rank ladder, DP/MRP mechanics, eligibility rules, code-of-conduct rules), the
  lesson is fully written and cites `source_ids` back to `compensation_rules.csv` or the OCR page.
  Where a named program (e.g. "RASCI Certification," "Millionaires Mindset Program (LEAP)," "NLP &
  Belief System") has no available content beyond its title, the lesson is a **shell**: `content`,
  `examples`, `quiz`, `estimated_minutes`, etc. are `NULL`, and `compliance_notes` explains exactly why
  and points to the gap report. No lesson content was invented to fill these gaps.
- **8 lessons are `content_provenance = GENERIC_METHODOLOGY`** — standard sales/business-skill training
  (prospecting, follow-up, objection handling, sales process, retention, planning, coaching) that isn't
  Dayjoy-specific. Every one of these lessons' `content` field is prefixed with
  `[Generic sales training content — not Dayjoy-specific, needs Dayjoy training team review before use]`
  and is cross-referenced to the relevant Dayjoy-sourced lesson where one exists.

## Compliance is non-negotiable in every row

Every lesson's `do_not_say` field carries a standard set of prohibitions: no guaranteed/typical income
figures (Dayjoy's own compensation plan disclaims this — see `compensation_rules.csv` row `COMM-002`),
no medical/cure/diagnosis claims, no rank-timeline promises, no competitor disparagement, and no citing
the 3 unresolved compensation conflicts (`CONF-001`/`CONF-002`/`CONF-003`) as settled fact. Lesson L13
("Business Plan Calculation & Strategy") is flagged as the highest compliance-risk lesson in the
curriculum for exactly this reason — its named topic is where an AI or leader is most likely to be
tempted to compute an unverified earnings number, and it deliberately does not.

See `01_CANONICAL/compensation/compensation_gap_report.csv` (gap G-004) for the recommended next step:
requesting the actual DAYJOY DRIVE training materials from the Dayjoy training team so the 11 current
shell lessons (content = NULL) can be filled in with real, sourced content.
