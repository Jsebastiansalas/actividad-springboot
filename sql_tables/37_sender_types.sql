-- 3. sender_types (Tipos de Remitente / Participante)
CREATE TABLE IF NOT EXISTS sender_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_type VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_sender_types_name_type UNIQUE (name_type)
);
COMMENT ON TABLE sender_types IS 'Rol del participante en el chat (Paciente, Profesional, Bot/AI, Moderador)';
