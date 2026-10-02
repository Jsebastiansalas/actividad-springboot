-- =============================================================================
-- Migration: V3__clinical_records_and_encounters.sql
-- Description: Módulo 3 - Historias clínicas, encuentros médicos, notas clínicas,
--              evaluación del estado mental, riesgos, planes de tratamiento y catálogos.
-- Database Engine: PostgreSQL
-- =============================================================================

-- =============================================================================
-- CATÁLOGOS AUXILIARES CLÍNICOS
-- =============================================================================

-- 1. clinical_record_statuses (Estados de la Historia Clínica)
CREATE TABLE IF NOT EXISTS clinical_record_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL,
    name VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_clinical_record_statuses_code UNIQUE (code),
    CONSTRAINT uk_clinical_record_statuses_name UNIQUE (name)
);
COMMENT ON TABLE clinical_record_statuses IS 'Estados del ciclo de vida de la historia clínica (Abierta, En Revisión, Cerrada, Archivada)';

-- 2. encounter_types (Tipos de Encuentro / Consulta)
CREATE TABLE IF NOT EXISTS encounter_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_encounter_types_code UNIQUE (code),
    CONSTRAINT uk_encounter_types_name UNIQUE (name)
);
COMMENT ON TABLE encounter_types IS 'Modalidad o tipo de sesión (Primera vez, Control, Urgencia, Interconsulta)';

-- 3. encounter_modalities (Modalidades de Atención)
CREATE TABLE IF NOT EXISTS encounter_modalities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_encounter_modalities_code UNIQUE (code)
);
COMMENT ON TABLE encounter_modalities IS 'Canal de atención clínica (Presencial, Telemedicina, Domiciliaria)';

-- 4. encounter_statuses (Estados del Encuentro Clínico)
CREATE TABLE IF NOT EXISTS encounter_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_encounter_statuses_code UNIQUE (code)
);
COMMENT ON TABLE encounter_statuses IS 'Estado del encuentro clínico (Programado, En curso, Completado, Cancelado)';

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

-- 6. treatment_statuses (Estados de Planes de Tratamiento)
CREATE TABLE IF NOT EXISTS treatment_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_treatment_statuses_code UNIQUE (code)
);
COMMENT ON TABLE treatment_statuses IS 'Estado general del plan de tratamiento (Activo, Pausado, Finalizado, Abandonado)';

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

-- 9. assessment_types (Tipos de Evaluación Clínica / Psicométrica)
CREATE TABLE IF NOT EXISTS assessment_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_assessment_types_code UNIQUE (code)
);
COMMENT ON TABLE assessment_types IS 'Clasificación de baterías y pruebas de evaluación psicológica o psiquiátrica';

-- 10. consent_types (Tipos de Consentimiento Informado)
CREATE TABLE IF NOT EXISTS consent_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_consent_types_code UNIQUE (code)
);
COMMENT ON TABLE consent_types IS 'Catálogo de modalidades de consentimiento informado';

-- 11. diagnostic_systems (Sistemas de Codificación Diagnóstica)
CREATE TABLE IF NOT EXISTS diagnostic_systems (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    version VARCHAR(20),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_diagnostic_systems_code UNIQUE (code)
);
COMMENT ON TABLE diagnostic_systems IS 'Clasificadores diagnósticos estándares (CIE-10, CIE-11, DSM-5)';

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

-- 13. encounters (Encuentros / Consultas Clínicas)
CREATE TABLE IF NOT EXISTS encounters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    clinical_record_id UUID NOT NULL,
    professional_id UUID NOT NULL,
    encounter_type_id UUID NOT NULL,
    started_at TIMESTAMPTZ NOT NULL,
    ended_at TIMESTAMPTZ,
    reason_for_visit TEXT,
    current_condition TEXT,
    modality_id UUID NOT NULL,
    status_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by UUID,
    CONSTRAINT fk_encounters_clinical_record FOREIGN KEY (clinical_record_id) 
        REFERENCES clinical_records(id) ON DELETE CASCADE,
    CONSTRAINT fk_encounters_professional FOREIGN KEY (professional_id) 
        REFERENCES professionals(id) ON DELETE RESTRICT,
    CONSTRAINT fk_encounters_type FOREIGN KEY (encounter_type_id) 
        REFERENCES encounter_types(id) ON DELETE RESTRICT,
    CONSTRAINT fk_encounters_modality FOREIGN KEY (modality_id) 
        REFERENCES encounter_modalities(id) ON DELETE RESTRICT,
    CONSTRAINT fk_encounters_status FOREIGN KEY (status_id) 
        REFERENCES encounter_statuses(id) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_encounters_clinical_record_id ON encounters(clinical_record_id);
CREATE INDEX IF NOT EXISTS idx_encounters_professional_id ON encounters(professional_id);
CREATE INDEX IF NOT EXISTS idx_encounters_type_id ON encounters(encounter_type_id);
CREATE INDEX IF NOT EXISTS idx_encounters_modality_id ON encounters(modality_id);
CREATE INDEX IF NOT EXISTS idx_encounters_status_id ON encounters(status_id);
CREATE INDEX IF NOT EXISTS idx_encounters_started_at ON encounters(started_at);

COMMENT ON TABLE encounters IS 'Sesión o consulta clínica entre paciente y profesional de la salud';

-- 14. clinical_notes (Notas de Evolución Médica / SOAP)
CREATE TABLE IF NOT EXISTS clinical_notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_id UUID NOT NULL,
    professional_id UUID NOT NULL,
    subjective TEXT,
    objective TEXT,
    assessment TEXT,
    plan TEXT,
    additional_notes TEXT,
    signed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_clinical_notes_encounter FOREIGN KEY (encounter_id) 
        REFERENCES encounters(id) ON DELETE CASCADE,
    CONSTRAINT fk_clinical_notes_professional FOREIGN KEY (professional_id) 
        REFERENCES professionals(id) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_clinical_notes_encounter_id ON clinical_notes(encounter_id);
CREATE INDEX IF NOT EXISTS idx_clinical_notes_professional_id ON clinical_notes(professional_id);

COMMENT ON TABLE clinical_notes IS 'Nota evolutiva estructurada bajo metodología SOAP (Subjetivo, Objetivo, Análisis, Plan)';

-- 15. mental_status_exams (Examen del Estado Mental - MSE)
CREATE TABLE IF NOT EXISTS mental_status_exams (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_id UUID NOT NULL,
    appearance TEXT,
    behavior TEXT,
    attitude TEXT,
    consciousness TEXT,
    orientation TEXT,
    attention TEXT,
    memory TEXT,
    speech TEXT,
    mood TEXT,
    affect TEXT,
    thought_process TEXT,
    thought_content TEXT,
    perception TEXT,
    judgment TEXT,
    insight TEXT,
    psychomotor_activity TEXT,
    observations TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    CONSTRAINT fk_mental_status_exams_encounter FOREIGN KEY (encounter_id) 
        REFERENCES encounters(id) ON DELETE CASCADE,
    CONSTRAINT fk_mental_status_exams_created_by FOREIGN KEY (created_by) 
        REFERENCES professionals(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_mental_status_exams_encounter_id ON mental_status_exams(encounter_id);
CREATE INDEX IF NOT EXISTS idx_mental_status_exams_created_by ON mental_status_exams(created_by);

COMMENT ON TABLE mental_status_exams IS 'Exploración psicopatológica y examen del estado mental por esferas cognitivas';

-- 16. risk_assessments (Evaluación de Riesgo Clínico y Suicida)
CREATE TABLE IF NOT EXISTS risk_assessments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_id UUID NOT NULL,
    risk_level_id UUID NOT NULL,
    suicidal_ideation BOOLEAN NOT NULL DEFAULT FALSE,
    suicide_plan BOOLEAN NOT NULL DEFAULT FALSE,
    suicide_intent BOOLEAN NOT NULL DEFAULT FALSE,
    self_harm BOOLEAN NOT NULL DEFAULT FALSE,
    harm_to_others BOOLEAN NOT NULL DEFAULT FALSE,
    risk_factors TEXT,
    protective_factors TEXT,
    clinical_actions TEXT,
    observations TEXT,
    assessed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    assessed_by UUID,
    CONSTRAINT fk_risk_assessments_encounter FOREIGN KEY (encounter_id) 
        REFERENCES encounters(id) ON DELETE CASCADE,
    CONSTRAINT fk_risk_assessments_risk_level FOREIGN KEY (risk_level_id) 
        REFERENCES risk_levels(id) ON DELETE RESTRICT,
    CONSTRAINT fk_risk_assessments_assessed_by FOREIGN KEY (assessed_by) 
        REFERENCES professionals(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_risk_assessments_encounter_id ON risk_assessments(encounter_id);
CREATE INDEX IF NOT EXISTS idx_risk_assessments_risk_level_id ON risk_assessments(risk_level_id);
CREATE INDEX IF NOT EXISTS idx_risk_assessments_assessed_by ON risk_assessments(assessed_by);

COMMENT ON TABLE risk_assessments IS 'Evaluación estructurada de ideación/conducta suicida y heteroagresión';

-- 17. treatment_plans (Planes de Tratamiento e Intervención)
CREATE TABLE IF NOT EXISTS treatment_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_id UUID NOT NULL,
    professional_id UUID NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE,
    treatment_status_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_treatment_plans_encounter FOREIGN KEY (encounter_id) 
        REFERENCES encounters(id) ON DELETE CASCADE,
    CONSTRAINT fk_treatment_plans_professional FOREIGN KEY (professional_id) 
        REFERENCES professionals(id) ON DELETE RESTRICT,
    CONSTRAINT fk_treatment_plans_status FOREIGN KEY (treatment_status_id) 
        REFERENCES treatment_statuses(id) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_treatment_plans_encounter_id ON treatment_plans(encounter_id);
CREATE INDEX IF NOT EXISTS idx_treatment_plans_professional_id ON treatment_plans(professional_id);
CREATE INDEX IF NOT EXISTS idx_treatment_plans_status_id ON treatment_plans(treatment_status_id);

COMMENT ON TABLE treatment_plans IS 'Plan global de tratamiento terapéutico o psiquiátrico formulado';

-- 18. treatment_goals (Objetivos Específicos del Plan de Tratamiento)
CREATE TABLE IF NOT EXISTS treatment_goals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    treatment_plan_id UUID NOT NULL,
    description TEXT NOT NULL,
    target_date DATE,
    completed_at TIMESTAMPTZ,
    notes TEXT,
    treatment_goal_status_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_treatment_goals_plan FOREIGN KEY (treatment_plan_id) 
        REFERENCES treatment_plans(id) ON DELETE CASCADE,
    CONSTRAINT fk_treatment_goals_status FOREIGN KEY (treatment_goal_status_id) 
        REFERENCES treatment_goal_statuses(id) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_treatment_goals_plan_id ON treatment_goals(treatment_plan_id);
CREATE INDEX IF NOT EXISTS idx_treatment_goals_status_id ON treatment_goals(treatment_goal_status_id);

COMMENT ON TABLE treatment_goals IS 'Metas y objetivos SMART definidos dentro del plan de tratamiento';
