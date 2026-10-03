-- 5. ai_runs_statuses (Estados de Ejecución del Agente/Modelo de IA)
CREATE TABLE IF NOT EXISTS ai_runs_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_status VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_ai_runs_statuses_name_status UNIQUE (name_status)
);
COMMENT ON TABLE ai_runs_statuses IS 'Estado de la invocación del modelo de IA (Iniciada, Procesando, Completada, Fallida, TimeOut)';
