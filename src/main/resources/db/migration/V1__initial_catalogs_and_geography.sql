-- =============================================================================
-- Migration: V1__initial_catalogs_and_geography.sql
-- Description: Módulo 1 - Ubicación geográfica, tipos de documentos y catálogos base.
-- Database Engine: PostgreSQL (UUID, TIMESTAMPTZ, snake_case)
-- =============================================================================

-- Extensiones necesarias para generación de UUIDs si no existen
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =============================================================================
-- 1. countries (Países)
-- =============================================================================
CREATE TABLE IF NOT EXISTS countries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_country VARCHAR(50) NOT NULL,
    code_country VARCHAR(10) NOT NULL,
    description VARCHAR(200),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    telephone_prefix VARCHAR(5),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_countries_code_country UNIQUE (code_country),
    CONSTRAINT uk_countries_name_country UNIQUE (name_country)
);

COMMENT ON TABLE countries IS 'Catálogo maestro de países y prefijos telefónicos';
COMMENT ON COLUMN countries.code_country IS 'Código ISO alfa-2 o alfa-3 del país';
COMMENT ON COLUMN countries.telephone_prefix IS 'Prefijo telefónico internacional (ej. +57, +1)';

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

-- =============================================================================
-- 4. document_types (Tipos de Documento de Identidad)
-- =============================================================================
CREATE TABLE IF NOT EXISTS document_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(10) NOT NULL,
    name VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_document_types_code UNIQUE (code),
    CONSTRAINT uk_document_types_name UNIQUE (name)
);

COMMENT ON TABLE document_types IS 'Tipos de documento de identidad (CC, TI, CE, Pasaporte, etc.)';

-- =============================================================================
-- 5. genders (Catálogo de Géneros y Sexo Biológico)
-- =============================================================================
CREATE TABLE IF NOT EXISTS genders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    description VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_genders_description UNIQUE (description)
);

COMMENT ON TABLE genders IS 'Catálogo general de sexo biológico e identidades de género';

-- =============================================================================
-- 6. relationship_types (Tipos de Parentesco / Relación de Contacto)
-- =============================================================================
CREATE TABLE IF NOT EXISTS relationship_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    description VARCHAR(50) NOT NULL,
    CONSTRAINT uk_relationship_types_description UNIQUE (description)
);

COMMENT ON TABLE relationship_types IS 'Tipos de relación para contactos de emergencia o familiares (Madre, Padre, Cónyuge, etc.)';

-- =============================================================================
-- 7. professional_types (Especialidades / Tipos de Profesionales)
-- =============================================================================
CREATE TABLE IF NOT EXISTS professional_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_professional_types_name UNIQUE (name)
);

COMMENT ON TABLE professional_types IS 'Clasificación de profesionales de salud (Psicólogo, Psiquiatra, Terapeuta, etc.)';

-- =============================================================================
-- 8. studies (Catálogo de Programas Académicos / Estudios)
-- =============================================================================
CREATE TABLE IF NOT EXISTS studies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(80) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_studies_name UNIQUE (name)
);

COMMENT ON TABLE studies IS 'Catálogo maestro de carreras, títulos o estudios profesionales';
