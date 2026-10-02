package com.demodd.domain.country.model.valueobject;

import com.demodd.domain.common.ValueObject;

/**
 * Value Object para la descripción opcional del país.
 */
public record CountryDescription(String value) implements ValueObject {

    public CountryDescription {
        if (value != null && value.length() > 200) {
            throw new IllegalArgumentException("La descripción del país no puede exceder 200 caracteres");
        }
    }

    public static CountryDescription of(String value) {
        return new CountryDescription(value);
    }

    public static CountryDescription empty() {
        return new CountryDescription(null);
    }
}
