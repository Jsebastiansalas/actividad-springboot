-- =============================================================================
-- TABLAS TRANSACCIONALES CLÍNICAS
-- =============================================================================

-- 12. clinical_records (Historias Clínicas)
CREATE TABLE IF NOT EXISTS clinical_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID NOT NULL,
    creation_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_number VARCHAR(50) NOT NULL,
    opened_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    closed_at TIMESTAMPTZ,
    status_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    CONSTRAINT fk_clinical_records_patient FOREIGN KEY (patient_id) 
        REFERENCES patients(id) ON DELETE RESTRICT,
    CONSTRAINT fk_clinical_records_status FOREIGN KEY (status_id) 
        REFERENCES clinical_record_statuses(id) ON DELETE RESTRICT,
    CONSTRAINT uk_clinical_records_record_number UNIQUE (record_number)
);

CREATE INDEX IF NOT EXISTS idx_clinical_records_patient_id ON clinical_records(patient_id);
CREATE INDEX IF NOT EXISTS idx_clinical_records_status_id ON clinical_records(status_id);

COMMENT ON TABLE clinical_records IS 'Expediente clínico o historia médica integral del paciente';
