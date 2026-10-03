# DemoDD – Plataforma de Salud Mental y Asistencia IA

Backend modular desarrollado con **Arquitectura Hexagonal (Ports & Adapters)** y **Domain-Driven Design (DDD)** sobre **Spring Boot 3.2.4** y **Java 17**, con persistencia en **PostgreSQL** versionada mediante **Flyway**.

---

## 1. Organización del Código

El proyecto está desacoplado en cuatro módulos Maven para garantizar que las reglas de negocio permanezcan independientes de frameworks y bases de datos:

* **`domain`**: El núcleo de negocio. Contiene modelos de dominio, Value Objects inmutables, excepciones de negocio, eventos y las interfaces de los puertos de salida (`*RepositoryPort`). No tiene dependencias de Spring ni de bibliotecas de terceros.
* **`application`**: Capa de aplicación. Define los casos de uso (puertos de entrada), los servicios orquestadores (`*ApplicationService`) y los objetos de transferencia de datos (DTOs y Commands).
* **`infrastructure`**: Capa de adaptadores externos. Implementa los controladores REST, las entidades de persistencia JPA/Hibernate, los repositorios de Spring Data, los mappers y los scripts SQL de Flyway.
* **`demo`**: Módulo de arranque y empaquetado. Contiene la clase principal `DemoApplication`, la configuración centralizada en `application.yml` y los perfiles de ejecución.

---

## 2. Puesta en Marcha

### Prerrequisitos
* Java Development Kit (JDK) 17 o superior.
* Apache Maven 3.8+.
* PostgreSQL 14+ (local o mediante contenedor).

### Pasos de ejecución
1. **Crear la base de datos:**
   Conectarse a PostgreSQL y ejecutar la creación de la base de datos vacía:
   ```sql
   CREATE DATABASE mental_health_db;
   ```
2. **Ajustar credenciales:**
   Verificar los parámetros de conexión en `demo/src/main/resources/application.yml` (por defecto apunta a `localhost:5432`, usuario `postgres`, contraseña `postgres`).
3. **Compilar el proyecto:**
   ```bash
   mvn clean install
   ```
4. **Iniciar la aplicación:**
   ```bash
   mvn spring-boot:run -pl demo
   ```
   Al arrancar, Flyway ejecutará automáticamente las migraciones pendientes en el orden `V1` -> `V2` -> `V3` -> `V4`, creando las 52 tablas con sus restricciones e índices.
5. **Verificación:**
   El endpoint de prueba de la entidad de referencia responderá en:
   ```
   GET http://localhost:8080/api/v1/countries
   ```

### Despliegue de Base de Datos con Docker
Si prefieres no instalar PostgreSQL directamente en el sistema operativo, puedes iniciar un contenedor con:
```bash
docker run -d \
  --name demodd-postgres \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=mental_health_db \
  -p 5432:5432 \
  postgres:16
```

---

## 3. Estructura de Base de Datos y Migraciones (52 Tablas)

El modelo de datos se encuentra distribuido en cuatro migraciones temáticas dentro de `infrastructure/src/main/resources/db/migration/`:

### Migración V1 — Geografía y Clasificadores Base (8 tablas)
Define la estructura territorial jerárquica y los catálogos fundamentales del sistema:
* **Ubicación:** `countries` (países y códigos telefónicos), `state_regions` (departamentos/estados) y `city_municipalities` (ciudades/municipios).
* **Catálogos generales:** `document_types` (identificaciones oficiales: CC, CE, Pasaporte), `genders` (sexo biológico e identidad), `relationship_types` (parentescos para contactos de apoyo), `professional_types` (ramas de la salud mental) y `studies` (carreras y programas académicos).

### Migración V2 — Personas, Profesionales y Pacientes (8 tablas)
Gestiona la información de pacientes, especialistas y directorio de redes de apoyo:
* **Directorio de Contactos:** `contacts` (acudientes y contactos de emergencia), `phone_contacts` (múltiples teléfonos) y `email_contacts` (correos electrónicos).
* **Profesionales Clínicos:** `professionals` (registro de terapeutas con número de licencia médica) y `professional_studies` (títulos certificados y resoluciones asociadas).
* **Pacientes:** `patients` (datos demográficos y residencia), `patient_contacts` (asociación entre pacientes y sus contactos clave) y `patient_allergies` (historial alergénico y severidad).

### Migración V3 — Expediente Clínico y Encuentros Médicos (18 tablas)
Sustenta la atención en consulta, notas clínicas, exámenes psicopatológicos y planes terapéuticos:
* **Catálogos Clínicos (11 tablas):** `clinical_record_statuses`, `encounter_types`, `encounter_modalities`, `encounter_statuses`, `risk_levels`, `treatment_statuses`, `treatment_goal_statuses`, `medication_routes`, `assessment_types`, `consent_types` y `diagnostic_systems`.
* **Atención y Evolución (7 tablas):**
  * `clinical_records`: Expediente clínico o historia médica integral del paciente.
  * `encounters`: Consultas o sesiones realizadas entre el paciente y el terapeuta.
  * `clinical_notes`: Notas de evolución clínica bajo estructura SOAP (Subjetivo, Objetivo, Análisis, Plan).
  * `mental_status_exams`: Examen del Estado Mental (MSE) por esferas cognitivas y afectivas.
  * `risk_assessments`: Evaluación de riesgo de ideación/conducta suicida y heteroagresión.
  * `treatment_plans`: Plan terapéutico formulado durante la atención.
  * `treatment_goals`: Objetivos y metas específicas SMART ligadas a cada plan de tratamiento.

### Migración V4 — Mensajería, Invocaciones IA y Escalamientos (18 tablas)
Provee la infraestructura para canales de chat, copiloto asistencial con modelos LLM y derivación asistida:
* **Catálogos de Comunicación (6 tablas):** `priorities`, `conversations_statuses`, `sender_types`, `message_types`, `ai_runs_statuses` y `escalations_statuses`.
* **Modelos y Proveedores LLM (2 tablas):** `provider_models_ai` (proveedores como OpenAI, Anthropic, Gemini) y `ai_models` (modelos específicos con cálculo de costos por token y ventanas de contexto).
* **Canal de Chat (4 tablas):** `chat_conversations` (hilos de conversación), `chat_participants` (miembros en la sala), `chat_conversation_ai_settings` (activación y modelo configurado por hilo) y `chat_messages` (mensajes con contenido flexible en formato `JSONB`).
* **Auditoría y Métricas de IA (3 tablas):** `chat_ai_runs` (trazabilidad de cada inferencia generada), `chat_ai_run_metrics` (consumo de prompt/completion tokens y gasto en USD) y `chat_ai_run_errors` (captura de errores técnicos de API o rate limits).
* **Escalamiento a Profesionales (3 tablas):** `chat_escalations` (tickets generados ante alertas clínicas), `chat_escalation_status_history` (historial de transiciones del ticket) y `chat_escalation_assignments` (asignación del paciente a un profesional disponible).

---

## 4. Decisiones Técnicas y Reglas de Persistencia

* **Claves Primarias:** Uso estandarizado de UUIDs autogenerados (`gen_random_uuid()`) para prevenir colisiones y evitar la exposición de identificadores secuenciales.
* **Control Temporal:** Marcas de tiempo almacenadas como `TIMESTAMPTZ` con valor por defecto `CURRENT_TIMESTAMP`.
* **Indexación:** Cada llave foránea cuenta con un índice B-Tree dedicado (`idx_*`) para optimizar los tiempos de consulta en operaciones de unión (`JOIN`).
* **Datos Semiestructurados:** Almacenamiento de payloads y metadatos de mensajería en columnas `JSONB` en `chat_messages`, indexadas con operadores GIN (`USING gin`).
* **Integridad Referencial:**
  * `ON DELETE RESTRICT`: Para catálogos, tipos de documento y entidades maestras, evitando borrados accidentales en cascada.
  * `ON DELETE CASCADE`: Para entidades que dependen estrictamente de su agregado padre (ej. teléfonos respecto a contactos, notas respecto a un encuentro o mensajes respecto a una conversación).
  * `ON DELETE SET NULL`: Para relaciones de auditoría o referencias opcionales (`created_by`, `city_id`).

---

## 5. Estado Actual del Repositorio

* **Completado:**
  * Estructura base multimódulo Maven configurada y compilando sin dependencias circulares.
  * 4 scripts Flyway que definen las 52 tablas con relaciones, índices y llaves foráneas.
  * Implementación de referencia vertical completa para la entidad `Country` (Domain -> Application -> Infrastructure -> REST API).
* **Próximas Fases:**
  * Implementación modular de los Bounded Contexts y generación de las entidades restantes siguiendo el patrón hexagonal establecido.
