-- =============================================================================
-- EJECUCIONES Y MÉTRICAS DE INTELIGENCIA ARTIFICIAL
-- =============================================================================

-- 13. chat_ai_runs (Invocaciones / Inferencia de Modelos de IA)
CREATE TABLE IF NOT EXISTS chat_ai_runs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL,
    message_id UUID,
    model_id UUID NOT NULL,
    ai_run_status_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chat_ai_runs_conversation FOREIGN KEY (conversation_id) 
        REFERENCES chat_conversations(id) ON DELETE CASCADE,
    CONSTRAINT fk_chat_ai_runs_message FOREIGN KEY (message_id) 
        REFERENCES chat_messages(id) ON DELETE SET NULL,
    CONSTRAINT fk_chat_ai_runs_model FOREIGN KEY (model_id) 
        REFERENCES ai_models(id) ON DELETE RESTRICT,
    CONSTRAINT fk_chat_ai_runs_status FOREIGN KEY (ai_run_status_id) 
        REFERENCES ai_runs_statuses(id) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_chat_ai_runs_conversation_id ON chat_ai_runs(conversation_id);
CREATE INDEX IF NOT EXISTS idx_chat_ai_runs_message_id ON chat_ai_runs(message_id);
CREATE INDEX IF NOT EXISTS idx_chat_ai_runs_model_id ON chat_ai_runs(model_id);
CREATE INDEX IF NOT EXISTS idx_chat_ai_runs_status_id ON chat_ai_runs(ai_run_status_id);

COMMENT ON TABLE chat_ai_runs IS 'Auditoría y trazabilidad de ejecuciones e inferencias realizadas por modelos de IA';
