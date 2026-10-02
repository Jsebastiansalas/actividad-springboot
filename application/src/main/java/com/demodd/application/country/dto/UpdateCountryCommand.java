package com.demodd.application.country.dto;

import java.util.UUID;

/**
 * Comando para actualizar un país existente.
 */
public record UpdateCountryCommand(
        UUID id,
        String name,
        String code,
        String description,
        String telephonePrefix
) {
}
