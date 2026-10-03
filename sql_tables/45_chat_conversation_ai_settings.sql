-- 11. chat_conversation_ai_settings (Configuración de IA para el Hilo)
CREATE TABLE IF NOT EXISTS chat_conversation_ai_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL,
    is_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    default_model_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chat_conv_ai_settings_conversation FOREIGN KEY (conversation_id) 
        REFERENCES chat_conversations(id) ON DELETE CASCADE,
    CONSTRAINT fk_chat_conv_ai_settings_model FOREIGN KEY (default_model_id) 
        REFERENCES ai_models(id) ON DELETE SET NULL,
    CONSTRAINT uk_chat_conv_ai_settings_conv UNIQUE (conversation_id)
);

CREATE INDEX IF NOT EXISTS idx_chat_conv_ai_settings_model_id ON chat_conversation_ai_settings(default_model_id);

COMMENT ON TABLE chat_conversation_ai_settings IS 'Parámetros y activación del copiloto de inteligencia artificial en una conversación';
