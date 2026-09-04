# Website Source Versioning Policy

## Why this folder exists
The Dayjoy public website carries company information, product listings, FAQs, support information, and business/compensation material — the same categories covered elsewhere in this repository. It must be treated as a **live source that changes without notice**, not as a one-time reference and not as the sole source of truth for any category. This folder is where dated snapshots of that site live once they're captured.

## Current status: EMPTY — no snapshot has been captured yet
No website content has been pulled into this repository. This is a deliberate gap, not an oversight: no site scrape or snapshot was provided as part of this build, and nothing about the live site has been invented or assumed. Do not treat any claim in `01_CANONICAL/` as website-sourced unless it appears in this folder with a logged snapshot entry.

## Rule: the website is versioned like any other source, not trusted like one
Because the site can change at any time, content pulled from it must go through the same pipeline as a PDF brochure — register it, extract it, verify it, flag conflicts — before it becomes canonical:

1. **Capture** — save the page as both a rendered snapshot (PDF or full-page screenshot) and, where possible, extracted text/HTML, named `YYYY-MM-DD_<page-slug>.<ext>` and stored in this folder.
2. **Log it** — add a row to `website_snapshot_log.csv` (template included) recording the URL, capture date, capture method, and a content hash of the snapshot.
3. **Register it** — add an entry in `08_GOVERNANCE/source_registry/` the same way a new PDF would be registered, per `dayjoy_source_verification_sop.md`.
4. **Cross-check, don't overwrite** — if a website claim conflicts with an existing canonical value (pricing, compensation, product claims), it goes into the conflict-tracking pattern already used in `01_CANONICAL/compensation/dayjoy_compensation_conflicts.csv` — flagged, not silently resolved.
5. **Re-snapshot on a cadence** — because the site is live, a snapshot older than a defined freshness window (recommend 30 days for pricing/compensation pages, 90 days for company/FAQ pages) should be treated as stale and re-captured before being relied on again.

## What NOT to do
- Do not let the AI Brain fetch the live site at answer time and treat that as ground truth — unversioned, unlogged content bypasses every governance control in this repository.
- Do not assume the website agrees with the PDF/brochure sources already in this repository. Web copy and print/PDF collateral drift apart over time; that's exactly why both need independent verification.
- Do not backfill this folder with paraphrased or remembered website content. Only actual captured snapshots belong here.

## Next action
When a snapshot capture process is available (manual save, scheduled crawler, or browser-tool capture), populate `website_snapshot_log.csv` and this folder, then route new/conflicting facts through `08_GOVERNANCE/source_registry/` before they touch `01_CANONICAL/`.
