# Compensation Knowledge — How These Files Relate

This folder holds Dayjoy's compensation-plan facts in two layers: **source files** (the original
extracts this folder was built from) and **structured knowledge files** (built on top of the sources,
for direct AI/RAG consumption). Read them in this order of authority:

## 1. Source files (highest authority, unchanged)

- `dayjoy_plan_ranks_rewards_VERIFIED.csv` — 17 ranks, OCR-verified field-by-field against the
  Dayjoy GrowthX Plan Presentation (pages 36-51). **Highest-authority compensation source in this repo.**
- `dayjoy_compensation_plan_ADDITIONAL_VERIFIED.csv`, `dayjoy_compensation_terms_and_conditions.csv` —
  additional OCR-verified rules (cashback tiers, loyalty programs, eligibility BV thresholds, the plan's
  10 numbered Terms & Conditions).
- `dayjoy_compensation_conflicts.csv` — **3 unresolved conflicts** between an older, uncited internal
  CSV (`dayjoy_compensation_plan.csv`) and the OCR-verified PDF: Retail Profit %, Mentorship Bonus %,
  and Business Matching Incentive structure. **These are not resolved anywhere in this folder** — by
  design. No file in this repo should ever be edited to "pick a winner" for these three fields without
  a written decision from the Dayjoy compensation team.
- `dayjoy_plan_faq_knowledge.csv` — supporting research, OCR-traceable.
- `distributor_system_narrative_UNSTRUCTURED.md` — **NOT a Dayjoy source document.** Provenance
  re-investigated 2026-08-10 (see `compensation_gap_report.csv`, gap G-002, "PROVENANCE RESOLVED"):
  this file is `04_Distributor_System.md`, the deliverable of "Mission 4" in a 12-mission **AI
  web-research pipeline** (`08_GOVERNANCE/source_registry/file_inventory.csv` traces it to
  `artifacts-1of3.zip > artifacts.zip`, not any raw Dayjoy PDF folder; the archived research log at
  `99_ARCHIVE/superseded/05_RESEARCH_LOG.md` confirms the mission structure). Its compensation section
  (§5) cites "Business_compensation_plan.pdf" via a `[web:68]` tag, but the document's own Section 21.4
  ("Uploaded Documents" — the files the research agent actually had) does **not** include that PDF; it
  only appears as a website URL the AI cited without demonstrated evidence of ever fetching or parsing
  it. No copy or OCR extract of `Business_compensation_plan.pdf` exists anywhere in this repo. **This
  is not a second real, conflicting company document — it is unverified AI-generated narrative content
  and must not be used as a compensation source at all**, let alone blended with the OCR-verified
  GrowthX figures. Anything in `compensation_rules.csv` sourced only to this file stays `UNVERIFIED`.

## 2. Structured knowledge files (built for this task)

- **`compensation_rules.csv`** — every extractable compensation rule, one row per rule, each carrying
  its own `verification_status` (`VERIFIED` / `UNVERIFIED` / `CONFLICT`), `source_id`, and `confidence`.
  This is the file an AI assistant should query first. 81 rows: 48 VERIFIED (traceable to the OCR'd
  GrowthX Plan Presentation or its verified derivative CSVs), 30 UNVERIFIED (single-sourced to the
  narrative document or the old uncited CSV, not corroborated), 3 CONFLICT (the 3 known unresolved
  items — pointing back to `dayjoy_compensation_conflicts.csv`, not re-deciding them).
- **`compensation_examples.csv`** — the *only* worked calculation examples that are literally printed
  in the GrowthX Plan Presentation OCR text, page-cited, always `is_illustrative_only=true`. No
  hypothetical or invented earnings scenario is in this file.
- **`compensation_gap_report.csv`** — everything a genuinely complete compensation knowledge base would
  need that could not be found or confirmed anywhere in this repo, with why it's missing, its impact,
  and a recommended next step.

## The one rule that matters most

**No AI reading this folder should ever compute or state a distributor's expected/guaranteed earnings.**
`compensation_rules.csv` row `COMM-002` carries the plan's own disclaimer: income illustrations are
informational only, and actual income depends entirely on performance and downline size. Any rule
marked `UNVERIFIED` or `CONFLICT` must never be combined with a `VERIFIED` rule to produce a number —
check `verification_status` before using any rate or threshold in a calculation.
