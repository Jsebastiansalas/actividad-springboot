package com.demodd.infrastructure.country.adapter.out.persistence;

import com.demodd.domain.country.model.aggregate.Country;
import com.demodd.domain.country.model.valueobject.CountryCode;
import com.demodd.domain.country.model.valueobject.CountryId;
import com.demodd.domain.country.model.valueobject.CountryName;
import com.demodd.domain.country.port.repository.CountryRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Adaptador de salida (Secondary Adapter) que implementa el puerto CountryRepository usando Spring Data JPA.
 */
@Repository
public class CountryRepositoryImpl implements CountryRepository {

    private final CountrySpringDataJpaRepository jpaRepository;
    private final CountryPersistenceMapper mapper;

    public CountryRepositoryImpl(CountrySpringDataJpaRepository jpaRepository, CountryPersistenceMapper mapper) {
        this.jpaRepository = jpaRepository;
        this.mapper = mapper;
    }

    @Override
    public Country save(Country country) {
        CountryJpaEntity jpaEntity = mapper.toJpaEntity(country);
        CountryJpaEntity saved = jpaRepository.save(jpaEntity);
        return mapper.toDomainEntity(saved);
    }

    @Override
    public Optional<Country> findById(CountryId id) {
        return jpaRepository.findById(id.value())
                .map(mapper::toDomainEntity);
    }

    @Override
    public Optional<Country> findByCode(CountryCode code) {
        return jpaRepository.findByCodeCountry(code.value())
                .map(mapper::toDomainEntity);
    }

    @Override
    public List<Country> findAll() {
        return jpaRepository.findAll().stream()
                .map(mapper::toDomainEntity)
                .toList();
    }

    @Override
    public List<Country> findAllActive() {
        return jpaRepository.findByIsActiveTrue().stream()
                .map(mapper::toDomainEntity)
                .toList();
    }

    @Override
    public boolean existsByCode(CountryCode code) {
        return jpaRepository.existsByCodeCountry(code.value());
    }

    @Override
    public boolean existsByName(CountryName name) {
        return jpaRepository.existsByNameCountry(name.value());
    }

    @Override
    public void deleteById(CountryId id) {
        jpaRepository.deleteById(id.value());
    }
}
