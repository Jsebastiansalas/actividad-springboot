-- 18. treatment_goals (Objetivos Específicos del Plan de Tratamiento)
CREATE TABLE IF NOT EXISTS treatment_goals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    treatment_plan_id UUID NOT NULL,
    description TEXT NOT NULL,
    target_date DATE,
    completed_at TIMESTAMPTZ,
    notes TEXT,
    treatment_goal_status_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_treatment_goals_plan FOREIGN KEY (treatment_plan_id) 
        REFERENCES treatment_plans(id) ON DELETE CASCADE,
    CONSTRAINT fk_treatment_goals_status FOREIGN KEY (treatment_goal_status_id) 
        REFERENCES treatment_goal_statuses(id) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_treatment_goals_plan_id ON treatment_goals(treatment_plan_id);
CREATE INDEX IF NOT EXISTS idx_treatment_goals_status_id ON treatment_goals(treatment_goal_status_id);

COMMENT ON TABLE treatment_goals IS 'Metas y objetivos SMART definidos dentro del plan de tratamiento';
