package com.demodd.infrastructure.country.adapter.out.persistence;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repositorio Spring Data JPA para la entidad CountryJpaEntity.
 */
@Repository
public interface CountrySpringDataJpaRepository extends JpaRepository<CountryJpaEntity, UUID> {

    Optional<CountryJpaEntity> findByCodeCountry(String codeCountry);

    List<CountryJpaEntity> findByIsActiveTrue();

    boolean existsByCodeCountry(String codeCountry);

    boolean existsByNameCountry(String nameCountry);
}
