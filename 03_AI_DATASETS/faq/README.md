# AI-Dataset FAQ Slice — pointer, not a separate dataset

There is one canonical FAQ dataset in this repository: `01_CANONICAL/faq/dayjoy_faq_combined_canonical.csv`. This folder does not duplicate it.

Why this folder exists per the target structure: `03_AI_DATASETS/` is meant to hold data shaped specifically for AI training/eval use (intents, conversations, journeys), as distinct from `01_CANONICAL/` which holds the source-of-truth records. An AI-training-shaped FAQ variant (e.g., paraphrase-augmented, intent-tagged, or negative-example-augmented) does not exist yet — creating one would be new dataset generation, which was out of scope for this reorganization. Until that variant is built, retrieval and intent-matching against FAQs should read directly from `01_CANONICAL/faq/dayjoy_faq_combined_canonical.csv`, which already carries `faq_category`, `confidence`, and `source_document`/`source_page_or_section` columns.
