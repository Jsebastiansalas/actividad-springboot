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
