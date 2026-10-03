-- 7. treatment_goal_statuses (Estados de Objetivos Terapéuticos)
CREATE TABLE IF NOT EXISTS treatment_goal_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_treatment_goal_statuses_code UNIQUE (code)
);
COMMENT ON TABLE treatment_goal_statuses IS 'Estado de cada objetivo terapéutico (Pendiente, En progreso, Alcanzado, No logrado)';
