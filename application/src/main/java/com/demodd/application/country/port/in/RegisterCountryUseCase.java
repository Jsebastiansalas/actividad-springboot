package com.demodd.application.country.port.in;

import com.demodd.application.country.dto.CountryResponse;
import com.demodd.application.country.dto.RegisterCountryCommand;

/**
 * Puerto de Entrada (Input Port) para registrar países.
 */
public interface RegisterCountryUseCase {

    CountryResponse execute(RegisterCountryCommand command);
}
