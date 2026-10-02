package com.demodd.application.country.dto;

/**
 * Comando para registrar un nuevo país en el sistema.
 */
public record RegisterCountryCommand(
        String name,
        String code,
        String description,
        String telephonePrefix
) {
}
