package com.demodd.domain.country.event;

import com.demodd.domain.common.DomainEvent;
import com.demodd.domain.country.model.valueobject.CountryCode;
import com.demodd.domain.country.model.valueobject.CountryId;
import com.demodd.domain.country.model.valueobject.CountryName;

import java.time.Instant;
import java.util.UUID;

/**
 * Evento de dominio emitido cuando los datos de un país son actualizados.
 */
public record CountryUpdatedEvent(
        UUID eventId,
        CountryId countryId,
        CountryName name,
        CountryCode code,
        Instant occurredOn
) implements DomainEvent {

    public CountryUpdatedEvent(CountryId countryId, CountryName name, CountryCode code) {
        this(UUID.randomUUID(), countryId, name, code, Instant.now());
    }

    @Override
    public String eventType() {
        return "country.updated";
    }
}
