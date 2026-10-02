package com.demodd.domain.country.model.aggregate;

import com.demodd.domain.common.AggregateRoot;
import com.demodd.domain.country.event.CountryDeletedEvent;
import com.demodd.domain.country.event.CountryRegisteredEvent;
import com.demodd.domain.country.event.CountryUpdatedEvent;
import com.demodd.domain.country.model.valueobject.*;

import java.time.Instant;
import java.util.Objects;

/**
 * Raíz de Agregado (Aggregate Root) para la entidad País.
 * Encapsula las reglas del negocio, invariantes y emisión de eventos de dominio.
 */
public class Country extends AggregateRoot<CountryId> {

    private final CountryId id;
    private CountryName name;
    private CountryCode code;
    private CountryDescription description;
    private CountryIsActive isActive;
    private TelephonePrefix telephonePrefix;
    private final Instant createdAt;
    private Instant updatedAt;

    private Country(
            CountryId id,
            CountryName name,
            CountryCode code,
            CountryDescription description,
            CountryIsActive isActive,
            TelephonePrefix telephonePrefix,
            Instant createdAt,
            Instant updatedAt
    ) {
        this.id = Objects.requireNonNull(id, "El identificador del país es requerido");
        this.name = Objects.requireNonNull(name, "El nombre del país es requerido");
        this.code = Objects.requireNonNull(code, "El código del país es requerido");
        this.description = description != null ? description : CountryDescription.empty();
        this.isActive = isActive != null ? isActive : CountryIsActive.active();
        this.telephonePrefix = telephonePrefix;
        this.createdAt = createdAt != null ? createdAt : Instant.now();
        this.updatedAt = updatedAt != null ? updatedAt : Instant.now();
    }

    /**
     * Fábrica para crear y registrar un nuevo País en el dominio.
     * Emite el evento CountryRegisteredEvent.
     */
    public static Country register(
            CountryId id,
            CountryName name,
            CountryCode code,
            CountryDescription description,
            TelephonePrefix telephonePrefix
    ) {
        Country country = new Country(
                id,
                name,
                code,
                description,
                CountryIsActive.active(),
                telephonePrefix,
                Instant.now(),
                Instant.now()
        );
        country.recordEvent(new CountryRegisteredEvent(id, name, code));
        return country;
    }

    /**
     * Reconstituye el agregado desde la capa de persistencia sin emitir eventos.
     */
    public static Country reconstitute(
            CountryId id,
            CountryName name,
            CountryCode code,
            CountryDescription description,
            CountryIsActive isActive,
            TelephonePrefix telephonePrefix,
            Instant createdAt,
            Instant updatedAt
    ) {
        return new Country(
                id,
                name,
                code,
                description,
                isActive,
                telephonePrefix,
                createdAt,
                updatedAt
        );
    }

    /**
     * Actualiza la información básica del país.
     * Emite el evento CountryUpdatedEvent.
     */
    public void update(
            CountryName newName,
            CountryCode newCode,
            CountryDescription newDescription,
            TelephonePrefix newPrefix
    ) {
        this.name = Objects.requireNonNull(newName, "El nuevo nombre no puede ser nulo");
        this.code = Objects.requireNonNull(newCode, "El nuevo código no puede ser nulo");
        this.description = newDescription != null ? newDescription : CountryDescription.empty();
        this.telephonePrefix = newPrefix;
        this.updatedAt = Instant.now();

        recordEvent(new CountryUpdatedEvent(this.id, this.name, this.code));
    }

    /**
     * Desactiva el país (soft delete).
     * Emite el evento CountryDeletedEvent.
     */
    public void deactivate() {
        this.isActive = CountryIsActive.inactive();
        this.updatedAt = Instant.now();
        recordEvent(new CountryDeletedEvent(this.id));
    }

    /**
     * Reactiva el país.
     */
    public void activate() {
        this.isActive = CountryIsActive.active();
        this.updatedAt = Instant.now();
    }

    @Override
    public CountryId getId() {
        return id;
    }

    public CountryName getName() {
        return name;
    }

    public CountryCode getCode() {
        return code;
    }

    public CountryDescription getDescription() {
        return description;
    }

    public CountryIsActive getIsActive() {
        return isActive;
    }

    public TelephonePrefix getTelephonePrefix() {
        return telephonePrefix;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Country country)) return false;
        return Objects.equals(id, country.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
