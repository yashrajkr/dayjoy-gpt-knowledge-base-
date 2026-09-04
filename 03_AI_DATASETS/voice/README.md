# Dayjoy Voice AI Training Data

Previous state: this folder held only a placeholder README ("No voice AI examples exist yet") — see `99_ARCHIVE/superseded/voice_README_pre_2026-08-09.md` for the archived original and `09_QA/KNOWLEDGE_GAP_REPORT.md` for the gap this filled.

## What's here now
- `voice_training_examples.csv` — 17 seed examples of Dayjoy Q&A reworded for spoken/voice-assistant delivery (short sentences, numbers/currency/product codes phrased for TTS, no markdown). Columns: `voice_id, persona, topic, user_utterance, assistant_spoken_response, tts_notes, data_type, notes`.

Every `assistant_spoken_response` is a reworded version of an existing canonical fact from `03_AI_DATASETS/intents/dayjoy_intents_CANONICAL.csv`, `01_CANONICAL/compensation/dayjoy_plan_ranks_rewards_VERIFIED.csv`, or `08_GOVERNANCE/answer_policy/ABSTAIN_AND_LABELING_POLICY.md` — no new Dayjoy fact was introduced, only the phrasing was adapted for speech (e.g. "M R P" instead of "MRP", digit-by-digit license numbers, currency read as "rupees").

Each row's `data_type` is labeled `TRAINING/EVALUATION DATA — SYNTHETIC, NOT A COMPANY FACT` to prevent this file from ever being mistaken for a canonical source during retrieval or audits.

## Scope note
This is a seed set (~17 rows), not the full-volume voice training corpus. Bulk volume generation is deferred to the separate evaluation-dataset workstream referenced in `00_PROJECT_ARCHITECTURE/07_NEXT_ACTIONS.md`. These examples exist to establish the schema and phrasing conventions (TTS-safe numbers, abstain/escalation tone in spoken form) that any future bulk voice dataset should follow.

## Related
- `03_AI_DATASETS/conversations/conversation_examples_LABELED.csv` — multi-turn text conversation examples across Customer/Distributor/Leader/Support personas, same synthetic-data labeling convention.
- `08_GOVERNANCE/answer_policy/ABSTAIN_AND_LABELING_POLICY.md` — governs which claims must carry a disclaimer or abstain, in voice form as much as text form.
