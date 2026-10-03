-- =============================================================================
-- 6. patients (Pacientes)
-- =============================================================================
CREATE TABLE IF NOT EXISTS patients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_type_id UUID NOT NULL,
    document_number VARCHAR(30) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    second_last_name VARCHAR(50),
    birth_date DATE NOT NULL,
    biological_sex_id UUID NOT NULL,
    gender_identity_id UUID NOT NULL,
    email VARCHAR(150),
    phone VARCHAR(30),
    address VARCHAR(250),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by UUID,
    city_id UUID,
    CONSTRAINT fk_patients_document_type FOREIGN KEY (document_type_id) 
        REFERENCES document_types(id) ON DELETE RESTRICT,
    CONSTRAINT fk_patients_biological_sex FOREIGN KEY (biological_sex_id) 
        REFERENCES genders(id) ON DELETE RESTRICT,
    CONSTRAINT fk_patients_gender_identity FOREIGN KEY (gender_identity_id) 
        REFERENCES genders(id) ON DELETE RESTRICT,
    CONSTRAINT fk_patients_city FOREIGN KEY (city_id) 
        REFERENCES city_municipalities(id) ON DELETE SET NULL,
    CONSTRAINT uk_patients_doc UNIQUE (document_type_id, document_number),
    CONSTRAINT uk_patients_email UNIQUE (email)
);

CREATE INDEX IF NOT EXISTS idx_patients_document_type_id ON patients(document_type_id);
CREATE INDEX IF NOT EXISTS idx_patients_biological_sex_id ON patients(biological_sex_id);
CREATE INDEX IF NOT EXISTS idx_patients_gender_identity_id ON patients(gender_identity_id);
CREATE INDEX IF NOT EXISTS idx_patients_city_id ON patients(city_id);

COMMENT ON TABLE patients IS 'Datos demográficos e información principal del paciente';
