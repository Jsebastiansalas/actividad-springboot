package com.demodd.domain.country.model.valueobject;

import com.demodd.domain.common.ValueObject;

/**
 * Value Object para el prefijo telefónico internacional (ej. +57, +1).
 */
public record TelephonePrefix(String value) implements ValueObject {

    public TelephonePrefix {
        if (value != null) {
            value = value.trim();
            if (value.length() > 5) {
                throw new IllegalArgumentException("El prefijo telefónico no puede tener más de 5 caracteres");
            }
        }
    }

    public static TelephonePrefix of(String value) {
        return new TelephonePrefix(value);
    }
}
