-- 3. encounter_modalities (Modalidades de Atención)
CREATE TABLE IF NOT EXISTS encounter_modalities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_encounter_modalities_code UNIQUE (code)
);
COMMENT ON TABLE encounter_modalities IS 'Canal de atención clínica (Presencial, Telemedicina, Domiciliaria)';
