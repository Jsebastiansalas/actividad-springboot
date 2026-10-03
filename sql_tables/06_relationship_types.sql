-- =============================================================================
-- 6. relationship_types (Tipos de Parentesco / Relación de Contacto)
-- =============================================================================
CREATE TABLE IF NOT EXISTS relationship_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    description VARCHAR(50) NOT NULL,
    CONSTRAINT uk_relationship_types_description UNIQUE (description)
);

COMMENT ON TABLE relationship_types IS 'Tipos de relación para contactos de emergencia o familiares (Madre, Padre, Cónyuge, etc.)';
