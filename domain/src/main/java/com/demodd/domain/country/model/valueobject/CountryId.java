package com.demodd.domain.country.model.valueobject;

import com.demodd.domain.common.ValueObject;

import java.util.Objects;
import java.util.UUID;

/**
 * Value Object para el identificador único del país.
 */
public record CountryId(UUID value) implements ValueObject {

    public CountryId {
        Objects.requireNonNull(value, "El ID del país no puede ser nulo");
    }

    public static CountryId random() {
        return new CountryId(UUID.randomUUID());
    }

    public static CountryId fromString(String uuid) {
        return new CountryId(UUID.fromString(uuid));
    }

    public static CountryId of(UUID value) {
        return new CountryId(value);
    }
}
