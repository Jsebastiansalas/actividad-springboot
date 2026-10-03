-- =============================================================================
-- 4. professionals (Personal de Salud y Profesionales Clínicos)
-- =============================================================================
CREATE TABLE IF NOT EXISTS professionals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_type_id UUID NOT NULL,
    document_number VARCHAR(30) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    professional_type_id UUID NOT NULL,
    license_number VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    city_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_professionals_document_type FOREIGN KEY (document_type_id) 
        REFERENCES document_types(id) ON DELETE RESTRICT,
    CONSTRAINT fk_professionals_type FOREIGN KEY (professional_type_id) 
        REFERENCES professional_types(id) ON DELETE RESTRICT,
    CONSTRAINT fk_professionals_city FOREIGN KEY (city_id) 
        REFERENCES city_municipalities(id) ON DELETE SET NULL,
    CONSTRAINT uk_professionals_doc UNIQUE (document_type_id, document_number),
    CONSTRAINT uk_professionals_license_number UNIQUE (license_number)
);

CREATE INDEX IF NOT EXISTS idx_professionals_document_type_id ON professionals(document_type_id);
CREATE INDEX IF NOT EXISTS idx_professionals_type_id ON professionals(professional_type_id);
CREATE INDEX IF NOT EXISTS idx_professionals_city_id ON professionals(city_id);

COMMENT ON TABLE professionals IS 'Registro de profesionales de la salud, especialistas y terapeutas';
COMMENT ON COLUMN professionals.license_number IS 'Tarjeta profesional o registro médico';
