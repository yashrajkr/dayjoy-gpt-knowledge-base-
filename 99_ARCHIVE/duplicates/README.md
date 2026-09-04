# Duplicates — manifest-based, not file-based

This folder does not contain physical copies of the ~1,696 exact-duplicate files found during the original audit. Storing 1,696 byte-identical copies would bloat the repository for zero informational value — the point of a duplicate record is knowing it existed and what it matched, not keeping the bytes twice.

The disposition of every duplicate is recorded in `99_ARCHIVE/archive_manifest.csv` (full disposition record) and `08_GOVERNANCE/audit/DUPLICATE_REPORT.md` (narrative findings). If you need to confirm a specific file was a duplicate and of what, look it up there by filename or SHA-256 hash.

One exception exists in `06_IMAGES/`: 92 image files were found to be byte-identical accidental re-copies (from a tooling rerun, not a legitimate second photo) and were excluded from `06_IMAGES/products/` for the same reason. They are not physically retained here either — see `08_GOVERNANCE/audit/` and the CHANGELOG for that specific fix.
