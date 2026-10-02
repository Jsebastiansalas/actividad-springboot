package com.demodd.domain.country.model.valueobject;

import com.demodd.domain.common.ValueObject;

/**
 * Value Object para el nombre oficial del país.
 */
public record CountryName(String value) implements ValueObject {

    public CountryName {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException("El nombre del país no puede estar vacío");
        }
        if (value.trim().length() > 50) {
            throw new IllegalArgumentException("El nombre del país no puede exceder 50 caracteres");
        }
        value = value.trim();
    }

    public static CountryName of(String value) {
        return new CountryName(value);
    }
}
