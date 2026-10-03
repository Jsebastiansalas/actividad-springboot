-- 4. encounter_statuses (Estados del Encuentro Clínico)
CREATE TABLE IF NOT EXISTS encounter_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_encounter_statuses_code UNIQUE (code)
);
COMMENT ON TABLE encounter_statuses IS 'Estado del encuentro clínico (Programado, En curso, Completado, Cancelado)';
