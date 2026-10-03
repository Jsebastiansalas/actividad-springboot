-- 10. chat_participants (Participantes de la Conversación)
CREATE TABLE IF NOT EXISTS chat_participants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL,
    participant_type_id UUID NOT NULL,
    patient_id UUID,
    professional_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chat_participants_conversation FOREIGN KEY (conversation_id) 
        REFERENCES chat_conversations(id) ON DELETE CASCADE,
    CONSTRAINT fk_chat_participants_type FOREIGN KEY (participant_type_id) 
        REFERENCES sender_types(id) ON DELETE RESTRICT,
    CONSTRAINT fk_chat_participants_patient FOREIGN KEY (patient_id) 
        REFERENCES patients(id) ON DELETE SET NULL,
    CONSTRAINT fk_chat_participants_professional FOREIGN KEY (professional_id) 
        REFERENCES professionals(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_chat_participants_conversation_id ON chat_participants(conversation_id);
CREATE INDEX IF NOT EXISTS idx_chat_participants_type_id ON chat_participants(participant_type_id);
CREATE INDEX IF NOT EXISTS idx_chat_participants_patient_id ON chat_participants(patient_id);
CREATE INDEX IF NOT EXISTS idx_chat_participants_prof_id ON chat_participants(professional_id);

COMMENT ON TABLE chat_participants IS 'Usuarios o agentes IA presentes en la sala de chat';
