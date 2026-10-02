package com.demodd.domain.country.event;

import com.demodd.domain.common.DomainEvent;
import com.demodd.domain.country.model.valueobject.CountryId;

import java.time.Instant;
import java.util.UUID;

/**
 * Evento de dominio emitido cuando un país es eliminado o desactivado.
 */
public record CountryDeletedEvent(
        UUID eventId,
        CountryId countryId,
        Instant occurredOn
) implements DomainEvent {

    public CountryDeletedEvent(CountryId countryId) {
        this(UUID.randomUUID(), countryId, Instant.now());
    }

    @Override
    public String eventType() {
        return "country.deleted";
    }
}
