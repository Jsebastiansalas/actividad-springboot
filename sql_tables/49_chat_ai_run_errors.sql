-- 15. chat_ai_run_errors (Errores durante la Inferencia de IA)
CREATE TABLE IF NOT EXISTS chat_ai_run_errors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ai_run_id UUID NOT NULL,
    error_message TEXT NOT NULL,
    error_code VARCHAR(50),
    provider_error_id VARCHAR(120),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chat_ai_run_errors_run FOREIGN KEY (ai_run_id) 
        REFERENCES chat_ai_runs(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_chat_ai_run_errors_run_id ON chat_ai_run_errors(ai_run_id);

COMMENT ON TABLE chat_ai_run_errors IS 'Registro de excepciones, rate limits y fallos de conectividad con proveedores de IA';
