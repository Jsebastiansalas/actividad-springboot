package com.demodd.domain.country.model.valueobject;

import com.demodd.domain.common.ValueObject;

/**
 * Value Object para el código internacional del país (ISO).
 */
public record CountryCode(String value) implements ValueObject {

    public CountryCode {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException("El código del país no puede estar vacío");
        }
        if (value.trim().length() > 10) {
            throw new IllegalArgumentException("El código del país no puede superar 10 caracteres");
        }
        value = value.trim().toUpperCase();
    }

    public static CountryCode of(String value) {
        return new CountryCode(value);
    }
}
