-- =============================================================================
-- 5. genders (Catálogo de Géneros y Sexo Biológico)
-- =============================================================================
CREATE TABLE IF NOT EXISTS genders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    description VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_genders_description UNIQUE (description)
);

COMMENT ON TABLE genders IS 'Catálogo general de sexo biológico e identidades de género';
