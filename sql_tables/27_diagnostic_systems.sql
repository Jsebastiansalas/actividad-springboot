-- 11. diagnostic_systems (Sistemas de Codificación Diagnóstica)
CREATE TABLE IF NOT EXISTS diagnostic_systems (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    version VARCHAR(20),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_diagnostic_systems_code UNIQUE (code)
);
COMMENT ON TABLE diagnostic_systems IS 'Clasificadores diagnósticos estándares (CIE-10, CIE-11, DSM-5)';
