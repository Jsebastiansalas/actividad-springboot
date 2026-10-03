-- =============================================================================
-- CONVERSACIONES Y COMUNICACIÓN INTERACTIVA
-- =============================================================================

-- 9. chat_conversations (Salas o Hilos de Conversación)
CREATE TABLE IF NOT EXISTS chat_conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_status_id UUID NOT NULL,
    priority_id UUID NOT NULL,
    last_message_at TIMESTAMPTZ,
    closed BOOLEAN NOT NULL DEFAULT FALSE,
    closed_at TIMESTAMPTZ,
    closed_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chat_conversations_status FOREIGN KEY (conversation_status_id) 
        REFERENCES conversations_statuses(id) ON DELETE RESTRICT,
    CONSTRAINT fk_chat_conversations_priority FOREIGN KEY (priority_id) 
        REFERENCES priorities(id) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_chat_conversations_status_id ON chat_conversations(conversation_status_id);
CREATE INDEX IF NOT EXISTS idx_chat_conversations_priority_id ON chat_conversations(priority_id);
CREATE INDEX IF NOT EXISTS idx_chat_conversations_last_msg ON chat_conversations(last_message_at);

COMMENT ON TABLE chat_conversations IS 'Sesión o hilo de mensajería sincrónica/asincrónica';
