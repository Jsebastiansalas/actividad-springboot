package com.demodd.domain.common;

import java.time.Instant;
import java.util.UUID;

/**
 * Contrato base para todos los eventos del dominio.
 */
public interface DomainEvent {

    /**
     * Identificador único del evento.
     */
    default UUID eventId() {
        return UUID.randomUUID();
    }

    /**
     * Momento exacto en que se produjo el evento en UTC.
     */
    Instant occurredOn();

    /**
     * Nombre descriptivo o tipo del evento de dominio.
     */
    String eventType();
}
