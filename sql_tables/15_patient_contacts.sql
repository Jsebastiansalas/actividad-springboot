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
