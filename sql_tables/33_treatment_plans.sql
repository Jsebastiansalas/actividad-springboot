-- 17. treatment_plans (Planes de Tratamiento e Intervención)
CREATE TABLE IF NOT EXISTS treatment_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_id UUID NOT NULL,
    professional_id UUID NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE,
    treatment_status_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_treatment_plans_encounter FOREIGN KEY (encounter_id) 
        REFERENCES encounters(id) ON DELETE CASCADE,
    CONSTRAINT fk_treatment_plans_professional FOREIGN KEY (professional_id) 
        REFERENCES professionals(id) ON DELETE RESTRICT,
    CONSTRAINT fk_treatment_plans_status FOREIGN KEY (treatment_status_id) 
        REFERENCES treatment_statuses(id) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_treatment_plans_encounter_id ON treatment_plans(encounter_id);
CREATE INDEX IF NOT EXISTS idx_treatment_plans_professional_id ON treatment_plans(professional_id);
CREATE INDEX IF NOT EXISTS idx_treatment_plans_status_id ON treatment_plans(treatment_status_id);

COMMENT ON TABLE treatment_plans IS 'Plan global de tratamiento terapéutico o psiquiátrico formulado';
