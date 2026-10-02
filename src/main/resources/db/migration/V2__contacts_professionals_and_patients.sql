-- =============================================================================
-- Migration: V2__contacts_professionals_and_patients.sql
-- Description: Módulo 2 - Contactos, Profesionales, Pacientes y sus relaciones.
-- Database Engine: PostgreSQL
-- =============================================================================

-- =============================================================================
-- 1. contacts (Directorio General de Contactos)
-- =============================================================================
CREATE TABLE IF NOT EXISTS contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name VARCHAR(200) NOT NULL,
    email VARCHAR(150),
    notes TEXT,
    city_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by UUID,
    CONSTRAINT fk_contacts_city FOREIGN KEY (city_id) 
        REFERENCES city_municipalities(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_contacts_city_id ON contacts(city_id);

COMMENT ON TABLE contacts IS 'Directorio de personas de contacto, acudientes y redes de apoyo';

-- =============================================================================
-- 2. phone_contacts (Teléfonos de Contactos)
-- =============================================================================
CREATE TABLE IF NOT EXISTS phone_contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contact_id UUID NOT NULL,
    phone VARCHAR(30) NOT NULL,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_phone_contacts_contact FOREIGN KEY (contact_id) 
        REFERENCES contacts(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_phone_contacts_contact_id ON phone_contacts(contact_id);

COMMENT ON TABLE phone_contacts IS 'Números telefónicos asociados a un contacto determinado';

-- =============================================================================
-- 3. email_contacts (Correos Electrónicos de Contactos)
-- =============================================================================
CREATE TABLE IF NOT EXISTS email_contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contact_id UUID NOT NULL,
    email VARCHAR(150) NOT NULL,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_email_contacts_contact FOREIGN KEY (contact_id) 
        REFERENCES contacts(id) ON DELETE CASCADE,
    CONSTRAINT uk_email_contacts_email UNIQUE (email)
);

CREATE INDEX IF NOT EXISTS idx_email_contacts_contact_id ON email_contacts(contact_id);

COMMENT ON TABLE email_contacts IS 'Direcciones de correo electrónico asociadas a un contacto';

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

-- =============================================================================
-- 5. professional_studies (Estudios y Títulos del Profesional)
-- =============================================================================
CREATE TABLE IF NOT EXISTS professional_studies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    study_id UUID NOT NULL,
    professional_id UUID NOT NULL,
    title VARCHAR(100) NOT NULL,
    university VARCHAR(150) NOT NULL,
    is_valid BOOLEAN NOT NULL DEFAULT TRUE,
    resolution_number VARCHAR(50),
    country_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_professional_studies_study FOREIGN KEY (study_id) 
        REFERENCES studies(id) ON DELETE RESTRICT,
    CONSTRAINT fk_professional_studies_professional FOREIGN KEY (professional_id) 
        REFERENCES professionals(id) ON DELETE CASCADE,
    CONSTRAINT fk_professional_studies_country FOREIGN KEY (country_id) 
        REFERENCES countries(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_professional_studies_study_id ON professional_studies(study_id);
CREATE INDEX IF NOT EXISTS idx_professional_studies_prof_id ON professional_studies(professional_id);
CREATE INDEX IF NOT EXISTS idx_professional_studies_country_id ON professional_studies(country_id);

COMMENT ON TABLE professional_studies IS 'Acreditación académica de los profesionales de salud';

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

-- =============================================================================
-- 7. patient_contacts (Relación Paciente - Contactos de Apoyo/Emergencia)
-- =============================================================================
CREATE TABLE IF NOT EXISTS patient_contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contact_id UUID NOT NULL,
    patient_id UUID NOT NULL,
    is_primary_contact BOOLEAN NOT NULL DEFAULT FALSE,
    is_emergency_contact BOOLEAN NOT NULL DEFAULT FALSE,
    relationship_type_id UUID NOT NULL,
    CONSTRAINT fk_patient_contacts_contact FOREIGN KEY (contact_id) 
        REFERENCES contacts(id) ON DELETE RESTRICT,
    CONSTRAINT fk_patient_contacts_patient FOREIGN KEY (patient_id) 
        REFERENCES patients(id) ON DELETE CASCADE,
    CONSTRAINT fk_patient_contacts_relationship FOREIGN KEY (relationship_type_id) 
        REFERENCES relationship_types(id) ON DELETE RESTRICT,
    CONSTRAINT uk_patient_contacts_patient_contact UNIQUE (patient_id, contact_id)
);

CREATE INDEX IF NOT EXISTS idx_patient_contacts_contact_id ON patient_contacts(contact_id);
CREATE INDEX IF NOT EXISTS idx_patient_contacts_patient_id ON patient_contacts(patient_id);
CREATE INDEX IF NOT EXISTS idx_patient_contacts_relationship_type_id ON patient_contacts(relationship_type_id);

COMMENT ON TABLE patient_contacts IS 'Asignación de personas de contacto a un paciente';

-- =============================================================================
-- 8. patient_allergies (Registro de Alergias del Paciente)
-- =============================================================================
CREATE TABLE IF NOT EXISTS patient_allergies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID NOT NULL,
    substance VARCHAR(200) NOT NULL,
    reaction TEXT,
    severity VARCHAR(20) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    recorded_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recorded_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_patient_allergies_patient FOREIGN KEY (patient_id) 
        REFERENCES patients(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_patient_allergies_patient_id ON patient_allergies(patient_id);

COMMENT ON TABLE patient_allergies IS 'Historial de sustancias alergénicas, reacciones y nivel de severidad';
