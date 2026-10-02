package com.demodd;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

/**
 * Punto de entrada principal de la aplicación Spring Boot.
 */
@SpringBootApplication(scanBasePackages = "com.demodd")
@EntityScan(basePackages = "com.demodd.infrastructure")
@EnableJpaRepositories(basePackages = "com.demodd.infrastructure")
public class DemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }
}
