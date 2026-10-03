-- 4. message_types (Tipos de Mensaje en el Chat)
CREATE TABLE IF NOT EXISTS message_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_type VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_message_types_name_type UNIQUE (name_type)
);
COMMENT ON TABLE message_types IS 'Formato del mensaje transmitido (Texto, Audio, Imagen, Archivo, Formulario, Evento del Sistema)';
