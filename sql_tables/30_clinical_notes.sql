-- 14. clinical_notes (Notas de Evolución Médica / SOAP)
CREATE TABLE IF NOT EXISTS clinical_notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_id UUID NOT NULL,
    professional_id UUID NOT NULL,
    subjective TEXT,
    objective TEXT,
    assessment TEXT,
    plan TEXT,
    additional_notes TEXT,
    signed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_clinical_notes_encounter FOREIGN KEY (encounter_id) 
        REFERENCES encounters(id) ON DELETE CASCADE,
    CONSTRAINT fk_clinical_notes_professional FOREIGN KEY (professional_id) 
        REFERENCES professionals(id) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_clinical_notes_encounter_id ON clinical_notes(encounter_id);
CREATE INDEX IF NOT EXISTS idx_clinical_notes_professional_id ON clinical_notes(professional_id);

COMMENT ON TABLE clinical_notes IS 'Nota evolutiva estructurada bajo metodología SOAP (Subjetivo, Objetivo, Análisis, Plan)';
