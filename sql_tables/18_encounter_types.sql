-- 2. encounter_types (Tipos de Encuentro / Consulta)
CREATE TABLE IF NOT EXISTS encounter_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_encounter_types_code UNIQUE (code),
    CONSTRAINT uk_encounter_types_name UNIQUE (name)
);
COMMENT ON TABLE encounter_types IS 'Modalidad o tipo de sesión (Primera vez, Control, Urgencia, Interconsulta)';
