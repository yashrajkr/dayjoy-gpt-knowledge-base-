CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE IF NOT EXISTS dayjoy_unified_rag_corpus (
    id BIGSERIAL PRIMARY KEY,
    chunk_id TEXT UNIQUE NOT NULL,
    parent_doc_id TEXT NOT NULL,
    chunk_index INTEGER NOT NULL,
    chunk_text TEXT NOT NULL,
    doc_type TEXT,
    source_document TEXT,
    source_section TEXT,
    product_name TEXT,
    product_code TEXT,
    sku TEXT,
    tags TEXT,
    keywords TEXT,
    category TEXT,
    confidence TEXT,
    source_reference TEXT,
    notes TEXT,
    embedding VECTOR(1536)
);
