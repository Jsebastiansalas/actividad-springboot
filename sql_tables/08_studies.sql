-- =============================================================================
-- 8. studies (Catálogo de Programas Académicos / Estudios)
-- =============================================================================
CREATE TABLE IF NOT EXISTS studies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(80) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_studies_name UNIQUE (name)
);

COMMENT ON TABLE studies IS 'Catálogo maestro de carreras, títulos o estudios profesionales';
