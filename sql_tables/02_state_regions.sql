-- =============================================================================
-- 2. state_regions (Estados / Departamentos / Regiones)
-- =============================================================================
CREATE TABLE IF NOT EXISTS state_regions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_region VARCHAR(50) NOT NULL,
    code_region VARCHAR(10) NOT NULL,
    description VARCHAR(200),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    country_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_state_regions_country FOREIGN KEY (country_id) 
        REFERENCES countries(id) ON DELETE RESTRICT,
    CONSTRAINT uk_state_regions_country_code UNIQUE (country_id, code_region)
);

CREATE INDEX IF NOT EXISTS idx_state_regions_country_id ON state_regions(country_id);

COMMENT ON TABLE state_regions IS 'Catálogo de departamentos o regiones pertenecientes a un país';
