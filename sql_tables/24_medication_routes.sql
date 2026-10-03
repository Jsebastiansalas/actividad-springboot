-- 8. medication_routes (Vías de Administración de Medicamentos)
CREATE TABLE IF NOT EXISTS medication_routes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_medication_routes_code UNIQUE (code)
);
COMMENT ON TABLE medication_routes IS 'Vías de administración farmacológica (Oral, Sublingual, Intravenosa, etc.)';
