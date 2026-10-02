package com.demodd.domain.common;

/**
 * Excepción base no comprobada para violaciones de reglas de negocio en el dominio.
 */
public abstract class DomainException extends RuntimeException {

    protected DomainException(String message) {
        super(message);
    }

    protected DomainException(String message, Throwable cause) {
        super(message, cause);
    }
}
