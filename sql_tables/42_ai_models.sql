-- 8. ai_models (Catálogo de Modelos LLM Específicos)
CREATE TABLE IF NOT EXISTS ai_models (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    provider_model_id UUID NOT NULL,
    name_model VARCHAR(100) NOT NULL,
    model_key VARCHAR(120) NOT NULL,
    input_token_price DECIMAL(12, 6) DEFAULT 0,
    output_token_price DECIMAL(12, 6) DEFAULT 0,
    max_tokens INTEGER,
    context_window INTEGER,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ai_models_provider FOREIGN KEY (provider_model_id) 
        REFERENCES provider_models_ai(id) ON DELETE RESTRICT,
    CONSTRAINT uk_ai_models_model_key UNIQUE (model_key)
);

CREATE INDEX IF NOT EXISTS idx_ai_models_provider_id ON ai_models(provider_model_id);

COMMENT ON TABLE ai_models IS 'Modelos de lenguaje disponibles para triaje y asistencia (ej. gpt-4o, claude-3-5-sonnet, gemini-1.5-pro)';
