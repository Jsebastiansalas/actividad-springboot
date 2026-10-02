package com.demodd.infrastructure.config;

import com.demodd.application.country.service.CountryApplicationService;
import com.demodd.domain.country.port.repository.CountryRepository;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Configuración de beans de Spring para inyectar servicios del módulo Application.
 * Mantiene el módulo Application agnóstico al framework de inyección de dependencias.
 */
@Configuration
public class CountryBeanConfig {

    @Bean
    public CountryApplicationService countryApplicationService(CountryRepository countryRepository) {
        return new CountryApplicationService(countryRepository);
    }
}
