package com.demodd.domain.common;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Clase base para raíces de agregado (Aggregate Roots) en DDD.
 * Gestiona el registro y despacho de Domain Events.
 *
 * @param <ID> Tipo del identificador del agregado.
 */
public abstract class AggregateRoot<ID> {

    private final List<DomainEvent> domainEvents = new ArrayList<>();

    public abstract ID getId();

    /**
     * Registra un evento de dominio ocurrido en el agregado.
     */
    protected void recordEvent(DomainEvent event) {
        if (event != null) {
            domainEvents.add(event);
        }
    }

    /**
     * Retorna y vacía la lista de eventos de dominio acumulados.
     */
    public List<DomainEvent> pullDomainEvents() {
        List<DomainEvent> events = new ArrayList<>(this.domainEvents);
        this.domainEvents.clear();
        return Collections.unmodifiableList(events);
    }

    /**
     * Obtiene una vista de solo lectura de los eventos acumulados.
     */
    public List<DomainEvent> getDomainEvents() {
        return Collections.unmodifiableList(this.domainEvents);
    }

    /**
     * Limpia los eventos acumulados.
     */
    public void clearDomainEvents() {
        this.domainEvents.clear();
    }
}
