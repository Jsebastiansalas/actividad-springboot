-- 2. conversations_statuses (Estados de la Conversación)
CREATE TABLE IF NOT EXISTS conversations_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_status VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_conversations_statuses_name_status UNIQUE (name_status)
);
COMMENT ON TABLE conversations_statuses IS 'Estados del canal de conversación (Abierta, En Espera, Escalda, Cerrada)';
