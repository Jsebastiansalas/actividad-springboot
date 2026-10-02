package com.demodd.application.country.port.in;

import java.util.UUID;

/**
 * Puerto de Entrada (Input Port) para eliminación lógica/desactivación de países.
 */
public interface DeleteCountryUseCase {

    void deactivate(UUID id);

    void delete(UUID id);
}
