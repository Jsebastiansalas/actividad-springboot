-- 18. chat_escalation_assignments (Asignación de Escalamiento a Profesional)
CREATE TABLE IF NOT EXISTS chat_escalation_assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    escalation_id UUID NOT NULL,
    professional_id UUID NOT NULL,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chat_escalation_assignments_escalation FOREIGN KEY (escalation_id) 
        REFERENCES chat_escalations(id) ON DELETE CASCADE,
    CONSTRAINT fk_chat_escalation_assignments_professional FOREIGN KEY (professional_id) 
        REFERENCES professionals(id) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_chat_escalation_assign_esc_id ON chat_escalation_assignments(escalation_id);
CREATE INDEX IF NOT EXISTS idx_chat_escalation_assign_prof_id ON chat_escalation_assignments(professional_id);

COMMENT ON TABLE chat_escalation_assignments IS 'Registro de profesionales de la salud asignados para atender el caso escalado';
