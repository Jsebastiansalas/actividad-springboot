package com.demodd.infrastructure.country.adapter.in.web;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record UpdateCountryRequest(
        @NotBlank(message = "El nombre del país es obligatorio")
        @Size(max = 50, message = "El nombre no puede superar los 50 caracteres")
        String name,

        @NotBlank(message = "El código del país es obligatorio")
        @Size(max = 10, message = "El código no puede superar los 10 caracteres")
        String code,

        @Size(max = 200, message = "La descripción no puede superar los 200 caracteres")
        String description,

        @Size(max = 5, message = "El prefijo telefónico no puede superar los 5 caracteres")
        String telephonePrefix
) {
}
