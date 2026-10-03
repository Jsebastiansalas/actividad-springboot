-- 17. chat_escalation_status_history (Historial de Cambios de Estado del Escalamiento)
CREATE TABLE IF NOT EXISTS chat_escalation_status_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    escalation_id UUID NOT NULL,
    escalation_status_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    changed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chat_escalation_history_escalation FOREIGN KEY (escalation_id) 
        REFERENCES chat_escalations(id) ON DELETE CASCADE,
    CONSTRAINT fk_chat_escalation_history_status FOREIGN KEY (escalation_status_id) 
        REFERENCES escalations_statuses(id) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_chat_escalation_history_esc_id ON chat_escalation_status_history(escalation_id);
CREATE INDEX IF NOT EXISTS idx_chat_escalation_history_st_id ON chat_escalation_status_history(escalation_status_id);

COMMENT ON TABLE chat_escalation_status_history IS 'Trazabilidad y auditoría de transiciones de estado del escalamiento';
