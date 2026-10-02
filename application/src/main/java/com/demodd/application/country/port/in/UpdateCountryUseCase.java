package com.demodd.application.country.port.in;

import com.demodd.application.country.dto.CountryResponse;
import com.demodd.application.country.dto.UpdateCountryCommand;

/**
 * Puerto de Entrada (Input Port) para actualizar datos de un país.
 */
public interface UpdateCountryUseCase {

    CountryResponse execute(UpdateCountryCommand command);
}
