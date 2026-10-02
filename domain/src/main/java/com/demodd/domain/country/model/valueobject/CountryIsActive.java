package com.demodd.domain.country.model.valueobject;

import com.demodd.domain.common.ValueObject;

/**
 * Value Object para el estado de actividad del país en el sistema.
 */
public record CountryIsActive(boolean value) implements ValueObject {

    public static CountryIsActive active() {
        return new CountryIsActive(true);
    }

    public static CountryIsActive inactive() {
        return new CountryIsActive(false);
    }

    public static CountryIsActive of(boolean value) {
        return new CountryIsActive(value);
    }
}
