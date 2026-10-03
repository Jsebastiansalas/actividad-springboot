-- 15. mental_status_exams (Examen del Estado Mental - MSE)
CREATE TABLE IF NOT EXISTS mental_status_exams (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_id UUID NOT NULL,
    appearance TEXT,
    behavior TEXT,
    attitude TEXT,
    consciousness TEXT,
    orientation TEXT,
    attention TEXT,
    memory TEXT,
    speech TEXT,
    mood TEXT,
    affect TEXT,
    thought_process TEXT,
    thought_content TEXT,
    perception TEXT,
    judgment TEXT,
    insight TEXT,
    psychomotor_activity TEXT,
    observations TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    CONSTRAINT fk_mental_status_exams_encounter FOREIGN KEY (encounter_id) 
        REFERENCES encounters(id) ON DELETE CASCADE,
    CONSTRAINT fk_mental_status_exams_created_by FOREIGN KEY (created_by) 
        REFERENCES professionals(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_mental_status_exams_encounter_id ON mental_status_exams(encounter_id);
CREATE INDEX IF NOT EXISTS idx_mental_status_exams_created_by ON mental_status_exams(created_by);

COMMENT ON TABLE mental_status_exams IS 'Exploración psicopatológica y examen del estado mental por esferas cognitivas';
