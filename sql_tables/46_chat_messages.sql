-- 12. chat_messages (Mensajes con Carga Útil Estructurada JSONB)
CREATE TABLE IF NOT EXISTS chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL,
    message_type_id UUID NOT NULL,
    participant_id UUID NOT NULL,
    content JSONB NOT NULL,
    metadata JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chat_messages_conversation FOREIGN KEY (conversation_id) 
        REFERENCES chat_conversations(id) ON DELETE CASCADE,
    CONSTRAINT fk_chat_messages_type FOREIGN KEY (message_type_id) 
        REFERENCES message_types(id) ON DELETE RESTRICT,
    CONSTRAINT fk_chat_messages_participant FOREIGN KEY (participant_id) 
        REFERENCES chat_participants(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_chat_messages_conversation_id ON chat_messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_chat_messages_type_id ON chat_messages(message_type_id);
CREATE INDEX IF NOT EXISTS idx_chat_messages_participant_id ON chat_messages(participant_id);
CREATE INDEX IF NOT EXISTS idx_chat_messages_created_at ON chat_messages(created_at);
CREATE INDEX IF NOT EXISTS idx_chat_messages_content_gin ON chat_messages USING gin (content);
CREATE INDEX IF NOT EXISTS idx_chat_messages_metadata_gin ON chat_messages USING gin (metadata);

COMMENT ON TABLE chat_messages IS 'Registro histórico de mensajes intercambiados en formato JSONB para máxima flexibilidad semántica';
COMMENT ON COLUMN chat_messages.content IS 'Payload principal del mensaje (texto, attachments, payload estructurado)';
COMMENT ON COLUMN chat_messages.metadata IS 'Metadatos adicionales (intent detected, sentiment, headers, client info)';
