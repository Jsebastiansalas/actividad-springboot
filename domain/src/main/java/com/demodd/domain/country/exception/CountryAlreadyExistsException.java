package com.demodd.domain.country.exception;

import com.demodd.domain.common.DomainException;
import com.demodd.domain.country.model.valueobject.CountryCode;

/**
 * Excepción lanzada cuando se intenta registrar un país con código o nombre duplicado.
 */
public class CountryAlreadyExistsException extends DomainException {

    public CountryAlreadyExistsException(CountryCode code) {
        super(String.format("Ya existe un país registrado con el código: %s", code.value()));
    }

    public CountryAlreadyExistsException(String message) {
        super(message);
    }
}
