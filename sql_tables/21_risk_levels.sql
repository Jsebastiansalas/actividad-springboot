-- 5. risk_levels (Niveles de Riesgo Clínico)
CREATE TABLE IF NOT EXISTS risk_levels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    severity INTEGER NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_risk_levels_code UNIQUE (code)
);
COMMENT ON TABLE risk_levels IS 'Clasificación de riesgo de seguridad (Bajo, Medio, Alto, Extremo)';
