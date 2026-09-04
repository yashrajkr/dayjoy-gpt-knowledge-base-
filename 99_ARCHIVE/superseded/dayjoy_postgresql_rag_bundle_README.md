# Dayjoy PostgreSQL RAG Bundle

This bundle contains PostgreSQL-ready exports for the unified Dayjoy RAG corpus.

## Files
- dayjoy_postgresql_schema.sql
- dayjoy_postgresql_inserts.sql
- dayjoy_postgresql_ready_corpus.csv
- dayjoy_postgresql_ready_corpus.json
- dayjoy_postgresql_ready_corpus.md
- dayjoy_postgresql_ready_corpus.xlsx
- dayjoy_postgresql_rag_bundle.zip

## Notes
- The schema enables the `vector` extension for pgvector-style embeddings.
- The table includes a `vector(1536)` embedding column ready for future embedding backfill.
- Chunk-level metadata is preserved for filtering and retrieval.
