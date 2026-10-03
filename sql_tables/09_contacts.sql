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
