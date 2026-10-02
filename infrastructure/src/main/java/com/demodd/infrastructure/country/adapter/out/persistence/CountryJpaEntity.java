package com.demodd.infrastructure.country.adapter.out.persistence;

import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;

/**
 * Entidad JPA para la tabla 'countries'.
 */
@Entity
@Table(name = "countries")
public class CountryJpaEntity {

    @Id
    @Column(name = "id", nullable = false, updatable = false)
    private UUID id;

    @Column(name = "name_country", nullable = false, length = 50, unique = true)
    private String nameCountry;

    @Column(name = "code_country", nullable = false, length = 10, unique = true)
    private String codeCountry;

    @Column(name = "description", length = 200)
    private String description;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive;

    @Column(name = "telephone_prefix", length = 5)
    private String telephonePrefix;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    public CountryJpaEntity() {
    }

    public CountryJpaEntity(
            UUID id,
            String nameCountry,
            String codeCountry,
            String description,
            Boolean isActive,
            String telephonePrefix,
            Instant createdAt,
            Instant updatedAt
    ) {
        this.id = id;
        this.nameCountry = nameCountry;
        this.codeCountry = codeCountry;
        this.description = description;
        this.isActive = isActive;
        this.telephonePrefix = telephonePrefix;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getNameCountry() {
        return nameCountry;
    }

    public void setNameCountry(String nameCountry) {
        this.nameCountry = nameCountry;
    }

    public String getCodeCountry() {
        return codeCountry;
    }

    public void setCodeCountry(String codeCountry) {
        this.codeCountry = codeCountry;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean active) {
        isActive = active;
    }

    public String getTelephonePrefix() {
        return telephonePrefix;
    }

    public void setTelephonePrefix(String telephonePrefix) {
        this.telephonePrefix = telephonePrefix;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Instant createdAt) {
        this.createdAt = createdAt;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Instant updatedAt) {
        this.updatedAt = updatedAt;
    }
}
