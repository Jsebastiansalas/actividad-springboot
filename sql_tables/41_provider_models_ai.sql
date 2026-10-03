-- =============================================================================
-- MODELOS Y PROVEEDORES DE INTELIGENCIA ARTIFICIAL
-- =============================================================================

-- 7. provider_models_ai (Proveedores de Servicios de IA)
CREATE TABLE IF NOT EXISTS provider_models_ai (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_provider_ai VARCHAR(100) NOT NULL,
    razon_social VARCHAR(150),
    sitio_web TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_provider_models_ai_name UNIQUE (name_provider_ai)
);
COMMENT ON TABLE provider_models_ai IS 'Proveedores de cómputo y LLM (OpenAI, Anthropic, Google Gemini, Ollama, Azure)';
