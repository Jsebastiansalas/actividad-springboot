package com.demodd.infrastructure.country.adapter.out.persistence;

import com.demodd.domain.country.model.aggregate.Country;
import com.demodd.domain.country.model.valueobject.*;
import org.springframework.stereotype.Component;

/**
 * Mapper bidireccional entre el modelo de Dominio (Country) y la entidad JPA (CountryJpaEntity).
 */
@Component
public class CountryPersistenceMapper {

    public CountryJpaEntity toJpaEntity(Country domain) {
        if (domain == null) return null;

        return new CountryJpaEntity(
                domain.getId().value(),
                domain.getName().value(),
                domain.getCode().value(),
                domain.getDescription() != null ? domain.getDescription().value() : null,
                domain.getIsActive().value(),
                domain.getTelephonePrefix() != null ? domain.getTelephonePrefix().value() : null,
                domain.getCreatedAt(),
                domain.getUpdatedAt()
        );
    }

    public Country toDomainEntity(CountryJpaEntity jpa) {
        if (jpa == null) return null;

        return Country.reconstitute(
                CountryId.of(jpa.getId()),
                CountryName.of(jpa.getNameCountry()),
                CountryCode.of(jpa.getCodeCountry()),
                CountryDescription.of(jpa.getDescription()),
                CountryIsActive.of(jpa.getIsActive() != null ? jpa.getIsActive() : true),
                jpa.getTelephonePrefix() != null ? TelephonePrefix.of(jpa.getTelephonePrefix()) : null,
                jpa.getCreatedAt(),
                jpa.getUpdatedAt()
        );
    }
}
