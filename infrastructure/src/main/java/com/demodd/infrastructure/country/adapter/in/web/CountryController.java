package com.demodd.infrastructure.country.adapter.in.web;

import com.demodd.application.country.dto.CountryResponse;
import com.demodd.application.country.dto.RegisterCountryCommand;
import com.demodd.application.country.dto.UpdateCountryCommand;
import com.demodd.application.country.port.in.DeleteCountryUseCase;
import com.demodd.application.country.port.in.GetCountryUseCase;
import com.demodd.application.country.port.in.RegisterCountryUseCase;
import com.demodd.application.country.port.in.UpdateCountryUseCase;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

/**
 * Adaptador Primario / Conductor (Primary / Driving Adapter) REST para la gestión de Países.
 */
@RestController
@RequestMapping("/api/v1/countries")
public class CountryController {

    private final RegisterCountryUseCase registerCountryUseCase;
    private final UpdateCountryUseCase updateCountryUseCase;
    private final GetCountryUseCase getCountryUseCase;
    private final DeleteCountryUseCase deleteCountryUseCase;

    public CountryController(
            RegisterCountryUseCase registerCountryUseCase,
            UpdateCountryUseCase updateCountryUseCase,
            GetCountryUseCase getCountryUseCase,
            DeleteCountryUseCase deleteCountryUseCase
    ) {
        this.registerCountryUseCase = registerCountryUseCase;
        this.updateCountryUseCase = updateCountryUseCase;
        this.getCountryUseCase = getCountryUseCase;
        this.deleteCountryUseCase = deleteCountryUseCase;
    }

    @PostMapping
    public ResponseEntity<CountryResponse> registerCountry(@Valid @RequestBody CreateCountryRequest request) {
        RegisterCountryCommand command = new RegisterCountryCommand(
                request.name(),
                request.code(),
                request.description(),
                request.telephonePrefix()
        );
        CountryResponse response = registerCountryUseCase.execute(command);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/{id}")
    public ResponseEntity<CountryResponse> getById(@PathVariable UUID id) {
        return ResponseEntity.ok(getCountryUseCase.getById(id));
    }

    @GetMapping("/code/{code}")
    public ResponseEntity<CountryResponse> getByCode(@PathVariable String code) {
        return ResponseEntity.ok(getCountryUseCase.getByCode(code));
    }

    @GetMapping
    public ResponseEntity<List<CountryResponse>> getAll(
            @RequestParam(required = false, defaultValue = "false") boolean onlyActive
    ) {
        if (onlyActive) {
            return ResponseEntity.ok(getCountryUseCase.getAllActive());
        }
        return ResponseEntity.ok(getCountryUseCase.getAll());
    }

    @PutMapping("/{id}")
    public ResponseEntity<CountryResponse> updateCountry(
            @PathVariable UUID id,
            @Valid @RequestBody UpdateCountryRequest request
    ) {
        UpdateCountryCommand command = new UpdateCountryCommand(
                id,
                request.name(),
                request.code(),
                request.description(),
                request.telephonePrefix()
        );
        return ResponseEntity.ok(updateCountryUseCase.execute(command));
    }

    @PatchMapping("/{id}/deactivate")
    public ResponseEntity<Void> deactivateCountry(@PathVariable UUID id) {
        deleteCountryUseCase.deactivate(id);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCountry(@PathVariable UUID id) {
        deleteCountryUseCase.delete(id);
        return ResponseEntity.noContent().build();
    }
}
