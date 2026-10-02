package com.demodd.domain.country.exception;

import com.demodd.domain.common.DomainException;
import com.demodd.domain.country.model.valueobject.CountryCode;
import com.demodd.domain.country.model.valueobject.CountryId;

/**
 * Excepción lanzada cuando no se encuentra un país solicitado.
 */
public class CountryNotFoundException extends DomainException {

    public CountryNotFoundException(CountryId countryId) {
        super(String.format("No se encontró el país con identificador: %s", countryId.value()));
    }

    public CountryNotFoundException(CountryCode code) {
        super(String.format("No se encontró el país con código ISO: %s", code.value()));
    }

    public CountryNotFoundException(String message) {
        super(message);
    }
}
