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
