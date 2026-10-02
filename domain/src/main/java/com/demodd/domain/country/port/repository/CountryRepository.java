package com.demodd.domain.country.port.repository;

import com.demodd.domain.country.model.aggregate.Country;
import com.demodd.domain.country.model.valueobject.CountryCode;
import com.demodd.domain.country.model.valueobject.CountryId;
import com.demodd.domain.country.model.valueobject.CountryName;

import java.util.List;
import java.util.Optional;

/**
 * Puerto de Salida (Output Port) del Dominio para la persistencia del agregado Country.
 * Define el contrato agnóstico a cualquier tecnología de base de datos.
 */
public interface CountryRepository {

    /**
     * Guarda o actualiza un país en el almacenamiento.
     */
    Country save(Country country);

    /**
     * Busca un país por su identificador único de dominio.
     */
    Optional<Country> findById(CountryId id);

    /**
     * Busca un país por su código ISO.
     */
    Optional<Country> findByCode(CountryCode code);

    /**
     * Retorna todos los países registrados.
     */
    List<Country> findAll();

    /**
     * Retorna todos los países activos.
     */
    List<Country> findAllActive();

    /**
     * Verifica si ya existe un país con el código indicado.
     */
    boolean existsByCode(CountryCode code);

    /**
     * Verifica si ya existe un país con el nombre indicado.
     */
    boolean existsByName(CountryName name);

    /**
     * Elimina físicamente un país por su identificador.
     */
    void deleteById(CountryId id);
}
