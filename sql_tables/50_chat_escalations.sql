-- =============================================================================
-- ESCALAMIENTOS A PROFESIONALES DE SALUD
-- =============================================================================

-- 16. chat_escalations (Tickets de Escalamiento Humano)
CREATE TABLE IF NOT EXISTS chat_escalations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL,
    status_id UUID NOT NULL,
    from_ai BOOLEAN NOT NULL DEFAULT FALSE,
    reason TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chat_escalations_conversation FOREIGN KEY (conversation_id) 
        REFERENCES chat_conversations(id) ON DELETE CASCADE,
    CONSTRAINT fk_chat_escalations_status FOREIGN KEY (status_id) 
        REFERENCES escalations_statuses(id) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_chat_escalations_conversation_id ON chat_escalations(conversation_id);
CREATE INDEX IF NOT EXISTS idx_chat_escalations_status_id ON chat_escalations(status_id);

COMMENT ON TABLE chat_escalations IS 'Manejo de alertas de derivación o escalamiento de un chat hacia atención humana';
