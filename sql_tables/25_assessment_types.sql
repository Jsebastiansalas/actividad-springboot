-- 9. assessment_types (Tipos de Evaluación Clínica / Psicométrica)
CREATE TABLE IF NOT EXISTS assessment_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_assessment_types_code UNIQUE (code)
);
COMMENT ON TABLE assessment_types IS 'Clasificación de baterías y pruebas de evaluación psicológica o psiquiátrica';
