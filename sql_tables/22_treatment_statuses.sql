-- 6. treatment_statuses (Estados de Planes de Tratamiento)
CREATE TABLE IF NOT EXISTS treatment_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_treatment_statuses_code UNIQUE (code)
);
COMMENT ON TABLE treatment_statuses IS 'Estado general del plan de tratamiento (Activo, Pausado, Finalizado, Abandonado)';
