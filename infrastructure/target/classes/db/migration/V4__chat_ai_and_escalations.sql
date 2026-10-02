-- =============================================================================
-- Migration: V4__chat_ai_and_escalations.sql
-- Description: Módulo 4 - Conversaciones, Participantes, Mensajes (JSONB),
--              Configuración de IA, Modelos, Métricas y Escalamientos a Profesionales.
-- Database Engine: PostgreSQL
-- =============================================================================

-- =============================================================================
-- CATÁLOGOS DEL MÓDULO DE COMUNICACIÓN E INTELIGENCIA ARTIFICIAL
-- =============================================================================

-- 1. priorities (Niveles de Prioridad de Conversaciones)
CREATE TABLE IF NOT EXISTS priorities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_priority VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_priorities_name_priority UNIQUE (name_priority)
);
COMMENT ON TABLE priorities IS 'Prioridades del chat de soporte/triaje (Baja, Media, Alta, Crítica)';

-- 2. conversations_statuses (Estados de la Conversación)
CREATE TABLE IF NOT EXISTS conversations_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_status VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_conversations_statuses_name_status UNIQUE (name_status)
);
COMMENT ON TABLE conversations_statuses IS 'Estados del canal de conversación (Abierta, En Espera, Escalda, Cerrada)';

-- 3. sender_types (Tipos de Remitente / Participante)
CREATE TABLE IF NOT EXISTS sender_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_type VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_sender_types_name_type UNIQUE (name_type)
);
COMMENT ON TABLE sender_types IS 'Rol del participante en el chat (Paciente, Profesional, Bot/AI, Moderador)';

-- 4. message_types (Tipos de Mensaje en el Chat)
CREATE TABLE IF NOT EXISTS message_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_type VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_message_types_name_type UNIQUE (name_type)
);
COMMENT ON TABLE message_types IS 'Formato del mensaje transmitido (Texto, Audio, Imagen, Archivo, Formulario, Evento del Sistema)';

-- 5. ai_runs_statuses (Estados de Ejecución del Agente/Modelo de IA)
CREATE TABLE IF NOT EXISTS ai_runs_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_status VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_ai_runs_statuses_name_status UNIQUE (name_status)
);
COMMENT ON TABLE ai_runs_statuses IS 'Estado de la invocación del modelo de IA (Iniciada, Procesando, Completada, Fallida, TimeOut)';

-- 6. escalations_statuses (Estados de Escalamiento Humano)
CREATE TABLE IF NOT EXISTS escalations_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_status VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_escalations_statuses_name_status UNIQUE (name_status)
);
COMMENT ON TABLE escalations_statuses IS 'Ciclo de vida del ticket de escalamiento hacia un profesional (Pendiente, En Atención, Resuelto, Descartado)';

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

-- =============================================================================
-- CONVERSACIONES Y COMUNICACIÓN INTERACTIVA
-- =============================================================================

-- 9. chat_conversations (Salas o Hilos de Conversación)
CREATE TABLE IF NOT EXISTS chat_conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_status_id UUID NOT NULL,
    priority_id UUID NOT NULL,
    last_message_at TIMESTAMPTZ,
    closed BOOLEAN NOT NULL DEFAULT FALSE,
    closed_at TIMESTAMPTZ,
    closed_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chat_conversations_status FOREIGN KEY (conversation_status_id) 
        REFERENCES conversations_statuses(id) ON DELETE RESTRICT,
    CONSTRAINT fk_chat_conversations_priority FOREIGN KEY (priority_id) 
        REFERENCES priorities(id) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_chat_conversations_status_id ON chat_conversations(conversation_status_id);
CREATE INDEX IF NOT EXISTS idx_chat_conversations_priority_id ON chat_conversations(priority_id);
CREATE INDEX IF NOT EXISTS idx_chat_conversations_last_msg ON chat_conversations(last_message_at);

COMMENT ON TABLE chat_conversations IS 'Sesión o hilo de mensajería sincrónica/asincrónica';

-- 10. chat_participants (Participantes de la Conversación)
CREATE TABLE IF NOT EXISTS chat_participants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL,
    participant_type_id UUID NOT NULL,
    patient_id UUID,
    professional_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chat_participants_conversation FOREIGN KEY (conversation_id) 
        REFERENCES chat_conversations(id) ON DELETE CASCADE,
    CONSTRAINT fk_chat_participants_type FOREIGN KEY (participant_type_id) 
        REFERENCES sender_types(id) ON DELETE RESTRICT,
    CONSTRAINT fk_chat_participants_patient FOREIGN KEY (patient_id) 
        REFERENCES patients(id) ON DELETE SET NULL,
    CONSTRAINT fk_chat_participants_professional FOREIGN KEY (professional_id) 
        REFERENCES professionals(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_chat_participants_conversation_id ON chat_participants(conversation_id);
CREATE INDEX IF NOT EXISTS idx_chat_participants_type_id ON chat_participants(participant_type_id);
CREATE INDEX IF NOT EXISTS idx_chat_participants_patient_id ON chat_participants(patient_id);
CREATE INDEX IF NOT EXISTS idx_chat_participants_prof_id ON chat_participants(professional_id);

COMMENT ON TABLE chat_participants IS 'Usuarios o agentes IA presentes en la sala de chat';

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

-- 12. chat_messages (Mensajes con Carga Útil Estructurada JSONB)
CREATE TABLE IF NOT EXISTS chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL,
    message_type_id UUID NOT NULL,
    participant_id UUID NOT NULL,
    content JSONB NOT NULL,
    metadata JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chat_messages_conversation FOREIGN KEY (conversation_id) 
        REFERENCES chat_conversations(id) ON DELETE CASCADE,
    CONSTRAINT fk_chat_messages_type FOREIGN KEY (message_type_id) 
        REFERENCES message_types(id) ON DELETE RESTRICT,
    CONSTRAINT fk_chat_messages_participant FOREIGN KEY (participant_id) 
        REFERENCES chat_participants(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_chat_messages_conversation_id ON chat_messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_chat_messages_type_id ON chat_messages(message_type_id);
CREATE INDEX IF NOT EXISTS idx_chat_messages_participant_id ON chat_messages(participant_id);
CREATE INDEX IF NOT EXISTS idx_chat_messages_created_at ON chat_messages(created_at);
CREATE INDEX IF NOT EXISTS idx_chat_messages_content_gin ON chat_messages USING gin (content);
CREATE INDEX IF NOT EXISTS idx_chat_messages_metadata_gin ON chat_messages USING gin (metadata);

COMMENT ON TABLE chat_messages IS 'Registro histórico de mensajes intercambiados en formato JSONB para máxima flexibilidad semántica';
COMMENT ON COLUMN chat_messages.content IS 'Payload principal del mensaje (texto, attachments, payload estructurado)';
COMMENT ON COLUMN chat_messages.metadata IS 'Metadatos adicionales (intent detected, sentiment, headers, client info)';

-- =============================================================================
-- EJECUCIONES Y MÉTRICAS DE INTELIGENCIA ARTIFICIAL
-- =============================================================================

-- 13. chat_ai_runs (Invocaciones / Inferencia de Modelos de IA)
CREATE TABLE IF NOT EXISTS chat_ai_runs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL,
    message_id UUID,
    model_id UUID NOT NULL,
    ai_run_status_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chat_ai_runs_conversation FOREIGN KEY (conversation_id) 
        REFERENCES chat_conversations(id) ON DELETE CASCADE,
    CONSTRAINT fk_chat_ai_runs_message FOREIGN KEY (message_id) 
        REFERENCES chat_messages(id) ON DELETE SET NULL,
    CONSTRAINT fk_chat_ai_runs_model FOREIGN KEY (model_id) 
        REFERENCES ai_models(id) ON DELETE RESTRICT,
    CONSTRAINT fk_chat_ai_runs_status FOREIGN KEY (ai_run_status_id) 
        REFERENCES ai_runs_statuses(id) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_chat_ai_runs_conversation_id ON chat_ai_runs(conversation_id);
CREATE INDEX IF NOT EXISTS idx_chat_ai_runs_message_id ON chat_ai_runs(message_id);
CREATE INDEX IF NOT EXISTS idx_chat_ai_runs_model_id ON chat_ai_runs(model_id);
CREATE INDEX IF NOT EXISTS idx_chat_ai_runs_status_id ON chat_ai_runs(ai_run_status_id);

COMMENT ON TABLE chat_ai_runs IS 'Auditoría y trazabilidad de ejecuciones e inferencias realizadas por modelos de IA';

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

-- =============================================================================
-- ESCALAMIENTOS A PROFESIONALES DE SALUD
-- =============================================================================

-- 16. chat_escalations (Tickets de Escalamiento Humano)
CREATE TABLE IF NOT EXISTS chat_escalations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL,
    status_id UUID NOT NULL,
    from_ai BOOLEAN NOT NULL DEFAULT FALSE,
    reason TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chat_escalations_conversation FOREIGN KEY (conversation_id) 
        REFERENCES chat_conversations(id) ON DELETE CASCADE,
    CONSTRAINT fk_chat_escalations_status FOREIGN KEY (status_id) 
        REFERENCES escalations_statuses(id) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_chat_escalations_conversation_id ON chat_escalations(conversation_id);
CREATE INDEX IF NOT EXISTS idx_chat_escalations_status_id ON chat_escalations(status_id);

COMMENT ON TABLE chat_escalations IS 'Manejo de alertas de derivación o escalamiento de un chat hacia atención humana';

-- 17. chat_escalation_status_history (Historial de Cambios de Estado del Escalamiento)
CREATE TABLE IF NOT EXISTS chat_escalation_status_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    escalation_id UUID NOT NULL,
    escalation_status_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    changed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chat_escalation_history_escalation FOREIGN KEY (escalation_id) 
        REFERENCES chat_escalations(id) ON DELETE CASCADE,
    CONSTRAINT fk_chat_escalation_history_status FOREIGN KEY (escalation_status_id) 
        REFERENCES escalations_statuses(id) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_chat_escalation_history_esc_id ON chat_escalation_status_history(escalation_id);
CREATE INDEX IF NOT EXISTS idx_chat_escalation_history_st_id ON chat_escalation_status_history(escalation_status_id);

COMMENT ON TABLE chat_escalation_status_history IS 'Trazabilidad y auditoría de transiciones de estado del escalamiento';

-- 18. chat_escalation_assignments (Asignación de Escalamiento a Profesional)
CREATE TABLE IF NOT EXISTS chat_escalation_assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    escalation_id UUID NOT NULL,
    professional_id UUID NOT NULL,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chat_escalation_assignments_escalation FOREIGN KEY (escalation_id) 
        REFERENCES chat_escalations(id) ON DELETE CASCADE,
    CONSTRAINT fk_chat_escalation_assignments_professional FOREIGN KEY (professional_id) 
        REFERENCES professionals(id) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_chat_escalation_assign_esc_id ON chat_escalation_assignments(escalation_id);
CREATE INDEX IF NOT EXISTS idx_chat_escalation_assign_prof_id ON chat_escalation_assignments(professional_id);

COMMENT ON TABLE chat_escalation_assignments IS 'Registro de profesionales de la salud asignados para atender el caso escalado';
