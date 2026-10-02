package com.demodd.domain.country.exception;

import com.demodd.domain.common.DomainException;

/**
 * Excepción lanzada cuando los datos del país violan invariantes o restricciones del dominio.
 */
public class InvalidCountryDataException extends DomainException {

    public InvalidCountryDataException(String message) {
        super(message);
    }

    public InvalidCountryDataException(String message, Throwable cause) {
        super(message, cause);
    }
}
