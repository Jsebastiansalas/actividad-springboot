-- =============================================================================
-- 4. document_types (Tipos de Documento de Identidad)
-- =============================================================================
CREATE TABLE IF NOT EXISTS document_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(10) NOT NULL,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_document_types_code UNIQUE (code),
    CONSTRAINT uk_document_types_name UNIQUE (name)
);

COMMENT ON TABLE document_types IS 'Tipos de documento de identidad (CC, TI, CE, Pasaporte, etc.)';
