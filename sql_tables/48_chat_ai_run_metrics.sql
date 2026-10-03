-- 14. chat_ai_run_metrics (Consumo de Tokens y Costos de Ejecución)
CREATE TABLE IF NOT EXISTS chat_ai_run_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ai_run_id UUID NOT NULL,
    prompt_tokens INTEGER NOT NULL DEFAULT 0,
    completion_tokens INTEGER NOT NULL DEFAULT 0,
    total_tokens INTEGER NOT NULL DEFAULT 0,
    cost DECIMAL(10, 6) NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chat_ai_run_metrics_run FOREIGN KEY (ai_run_id) 
        REFERENCES chat_ai_runs(id) ON DELETE CASCADE,
    CONSTRAINT uk_chat_ai_run_metrics_run UNIQUE (ai_run_id)
);

CREATE INDEX IF NOT EXISTS idx_chat_ai_run_metrics_run_id ON chat_ai_run_metrics(ai_run_id);

COMMENT ON TABLE chat_ai_run_metrics IS 'Métricas de consumo de tokens y facturación por inferencia';
