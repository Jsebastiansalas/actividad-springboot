package com.demodd.application.country.service;

import com.demodd.application.country.dto.CountryResponse;
import com.demodd.application.country.dto.RegisterCountryCommand;
import com.demodd.application.country.dto.UpdateCountryCommand;
import com.demodd.application.country.port.in.DeleteCountryUseCase;
import com.demodd.application.country.port.in.GetCountryUseCase;
import com.demodd.application.country.port.in.RegisterCountryUseCase;
import com.demodd.application.country.port.in.UpdateCountryUseCase;
import com.demodd.domain.country.exception.CountryAlreadyExistsException;
import com.demodd.domain.country.exception.CountryNotFoundException;
import com.demodd.domain.country.model.aggregate.Country;
import com.demodd.domain.country.model.valueobject.*;
import com.demodd.domain.country.port.repository.CountryRepository;

import java.util.List;
import java.util.UUID;

/**
 * Servicio de Aplicación que implementa los casos de uso para la entidad Country.
 * Orquesta la lógica del negocio con el puerto de persistencia del dominio.
 */
public class CountryApplicationService implements
        RegisterCountryUseCase,
        UpdateCountryUseCase,
        GetCountryUseCase,
        DeleteCountryUseCase {

    private final CountryRepository countryRepository;

    public CountryApplicationService(CountryRepository countryRepository) {
        this.countryRepository = countryRepository;
    }

    @Override
    public CountryResponse execute(RegisterCountryCommand command) {
        CountryCode code = CountryCode.of(command.code());
        CountryName name = CountryName.of(command.name());

        if (countryRepository.existsByCode(code)) {
            throw new CountryAlreadyExistsException(code);
        }

        Country country = Country.register(
                CountryId.random(),
                name,
                code,
                command.description() != null ? CountryDescription.of(command.description()) : CountryDescription.empty(),
                command.telephonePrefix() != null ? TelephonePrefix.of(command.telephonePrefix()) : null
        );

        Country saved = countryRepository.save(country);
        return CountryResponse.fromDomain(saved);
    }

    @Override
    public CountryResponse execute(UpdateCountryCommand command) {
        CountryId id = CountryId.of(command.id());
        Country country = countryRepository.findById(id)
                .orElseThrow(() -> new CountryNotFoundException(id));

        CountryName newName = CountryName.of(command.name());
        CountryCode newCode = CountryCode.of(command.code());

        country.update(
                newName,
                newCode,
                command.description() != null ? CountryDescription.of(command.description()) : CountryDescription.empty(),
                command.telephonePrefix() != null ? TelephonePrefix.of(command.telephonePrefix()) : null
        );

        Country updated = countryRepository.save(country);
        return CountryResponse.fromDomain(updated);
    }

    @Override
    public CountryResponse getById(UUID id) {
        CountryId countryId = CountryId.of(id);
        return countryRepository.findById(countryId)
                .map(CountryResponse::fromDomain)
                .orElseThrow(() -> new CountryNotFoundException(countryId));
    }

    @Override
    public CountryResponse getByCode(String code) {
        CountryCode countryCode = CountryCode.of(code);
        return countryRepository.findByCode(countryCode)
                .map(CountryResponse::fromDomain)
                .orElseThrow(() -> new CountryNotFoundException(countryCode));
    }

    @Override
    public List<CountryResponse> getAll() {
        return countryRepository.findAll().stream()
                .map(CountryResponse::fromDomain)
                .toList();
    }

    @Override
    public List<CountryResponse> getAllActive() {
        return countryRepository.findAllActive().stream()
                .map(CountryResponse::fromDomain)
                .toList();
    }

    @Override
    public void deactivate(UUID id) {
        CountryId countryId = CountryId.of(id);
        Country country = countryRepository.findById(countryId)
                .orElseThrow(() -> new CountryNotFoundException(countryId));

        country.deactivate();
        countryRepository.save(country);
    }

    @Override
    public void delete(UUID id) {
        CountryId countryId = CountryId.of(id);
        if (countryRepository.findById(countryId).isEmpty()) {
            throw new CountryNotFoundException(countryId);
        }
        countryRepository.deleteById(countryId);
    }
}
