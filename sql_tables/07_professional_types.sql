-- =============================================================================
-- 7. professional_types (Especialidades / Tipos de Profesionales)
-- =============================================================================
CREATE TABLE IF NOT EXISTS professional_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_professional_types_name UNIQUE (name)
);

COMMENT ON TABLE professional_types IS 'Clasificación de profesionales de salud (Psicólogo, Psiquiatra, Terapeuta, etc.)';
