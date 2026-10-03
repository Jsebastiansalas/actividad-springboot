-- Extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =============================================================================
-- 1. countries (Países)
-- =============================================================================
CREATE TABLE IF NOT EXISTS countries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_country VARCHAR(50) NOT NULL,
    code_country VARCHAR(10) NOT NULL,
    description VARCHAR(200),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    telephone_prefix VARCHAR(5),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_countries_code_country UNIQUE (code_country),
    CONSTRAINT uk_countries_name_country UNIQUE (name_country)
);

COMMENT ON TABLE countries IS 'Catálogo maestro de países y prefijos telefónicos';
COMMENT ON COLUMN countries.code_country IS 'Código ISO alfa-2 o alfa-3 del país';
COMMENT ON COLUMN countries.telephone_prefix IS 'Prefijo telefónico internacional (ej. +57, +1)';
