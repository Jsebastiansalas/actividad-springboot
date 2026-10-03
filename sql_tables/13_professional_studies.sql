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
