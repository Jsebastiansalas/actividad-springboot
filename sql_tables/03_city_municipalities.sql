-- =============================================================================
-- 3. city_municipalities (Ciudades / Municipios)
-- =============================================================================
CREATE TABLE IF NOT EXISTS city_municipalities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_city VARCHAR(50) NOT NULL,
    code_city VARCHAR(10) NOT NULL,
    description VARCHAR(200),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    region_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_city_municipalities_region FOREIGN KEY (region_id) 
        REFERENCES state_regions(id) ON DELETE RESTRICT,
    CONSTRAINT uk_city_municipalities_region_code UNIQUE (region_id, code_city)
);

CREATE INDEX IF NOT EXISTS idx_city_municipalities_region_id ON city_municipalities(region_id);

COMMENT ON TABLE city_municipalities IS 'Catálogo de municipios o ciudades asociadas a una región/departamento';
