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
