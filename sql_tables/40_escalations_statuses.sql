-- 6. escalations_statuses (Estados de Escalamiento Humano)
CREATE TABLE IF NOT EXISTS escalations_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_status VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_escalations_statuses_name_status UNIQUE (name_status)
);
COMMENT ON TABLE escalations_statuses IS 'Ciclo de vida del ticket de escalamiento hacia un profesional (Pendiente, En Atención, Resuelto, Descartado)';
