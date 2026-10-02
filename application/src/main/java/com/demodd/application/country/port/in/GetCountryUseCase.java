package com.demodd.application.country.port.in;

import com.demodd.application.country.dto.CountryResponse;

import java.util.List;
import java.util.UUID;

/**
 * Puerto de Entrada (Input Port) para consultas de países.
 */
public interface GetCountryUseCase {

    CountryResponse getById(UUID id);

    CountryResponse getByCode(String code);

    List<CountryResponse> getAll();

    List<CountryResponse> getAllActive();
}
