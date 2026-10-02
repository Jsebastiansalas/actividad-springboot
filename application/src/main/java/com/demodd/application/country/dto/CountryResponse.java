package com.demodd.application.country.dto;

import com.demodd.domain.country.model.aggregate.Country;

import java.time.Instant;
import java.util.UUID;

/**
 * DTO de respuesta con la información de un país.
 */
public record CountryResponse(
        UUID id,
        String name,
        String code,
        String description,
        String telephonePrefix,
        boolean isActive,
        Instant createdAt,
        Instant updatedAt
) {
    public static CountryResponse fromDomain(Country country) {
        return new CountryResponse(
                country.getId().value(),
                country.getName().value(),
                country.getCode().value(),
                country.getDescription().value(),
                country.getTelephonePrefix() != null ? country.getTelephonePrefix().value() : null,
                country.getIsActive().value(),
                country.getCreatedAt(),
                country.getUpdatedAt()
        );
    }
}
