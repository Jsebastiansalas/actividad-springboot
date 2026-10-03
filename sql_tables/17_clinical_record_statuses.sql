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
