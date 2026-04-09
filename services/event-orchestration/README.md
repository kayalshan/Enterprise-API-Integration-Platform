# Event Orchestration Service

This service hosts orchestration logic for event-driven workflows in the platform. It is structured as a Spring Boot application with clear separation between event consumption, orchestration services, retry handling, dead-letter processing, and supporting models and configuration.

## Structure

```text
event-orchestration-service/
├── src/main/java/com/company/orchestration/
│   ├── controller/
│   ├── consumer/
│   ├── service/
│   ├── model/
│   ├── config/
│   ├── retry/
│   ├── dlq/
│   └── saga/
├── src/main/resources/
│   ├── application.yml
│   ├── application-dev.yml
│   ├── application-local.yml
│   └── application-prod.yml
├── Dockerfile
├── pom.xml
├── README.md
└── tests/
```

## Package Responsibilities

- `controller/`: HTTP endpoint used for manual triggering, e2e validation, and OpenAPI exposure.
- `consumer/`: event listeners and inbound message handling.
- `service/`: orchestration use cases and coordination logic.
- `model/`: request, response, and workflow domain models.
- `config/`: Spring configuration and infrastructure wiring.
- `retry/`: retry policies and retry-related helpers.
- `dlq/`: dead-letter queue handling and recovery flows.
- `saga/`: saga coordination components already present in the service.

## Flow Alignment

The service now exposes a domain-neutral orchestration pipeline for distributed integration flows:

- A generic event envelope enters the service via Kafka consumer or REST test endpoint.
- `resourceId` is the platform-level business key used for orchestration correlation, retries, and DLQ routing.
- The pipeline executes `validate-event`, `enrich-payload`, and `dispatch-downstream` in sequence.
- A business failure at `enrich-payload` or `dispatch-downstream` returns a compensation response aligned to distributed integration processing.
- Unexpected technical failures are routed through retry policy and then to DLQ after retry exhaustion.

## Test And Contract Artifacts

- OpenAPI contract: `api-platform/openapi/event-orchestration-service.yaml`
- Postman collection: `api-platform/postman/event-orchestration-service.postman_collection.json`
- Unit and e2e tests: `services/event-orchestration-service/tests/`

## Build And Run

From the repository root:

```bash
mvn -pl services/event-orchestration-service test
mvn -pl services/event-orchestration-service spring-boot:run
```

Run only the end-to-end controller coverage:

```bash
mvn -pl services/event-orchestration-service -Dtest=EventOrchestrationControllerE2ETest test
```

Build the container image from the service directory:

```bash
docker build -t event-orchestration-service services/event-orchestration-service
```

## Sample Input And Expected Output

### Event processing — success path

Request:

```json
{
  "eventId": "evt-1001",
  "eventType": "customer.updated.v1",
  "resourceId": "resource-42",
  "sourceSystem": "crm",
  "payload": {
    "status": "ACTIVE",
    "region": "eu-west-1"
  }
}
```

Expected response (`202 Accepted`):

```json
{
  "status": "PROCESSING_IN_PROGRESS",
  "executedSteps": [
    "validate-event",
    "enrich-payload",
    "dispatch-downstream"
  ],
  "emittedEvent": "orchestration.processing.started.v1"
}
```

### Event processing — compensation path

Request:

```json
{
  "eventId": "evt-1002",
  "eventType": "customer.updated.v1",
  "resourceId": "resource-99",
  "sourceSystem": "crm",
  "payload": {
    "status": "SUSPENDED"
  },
  "simulateFailureStep": "dispatch-downstream"
}
```

Expected response (`202 Accepted`):

```json
{
  "status": "COMPENSATION_TRIGGERED",
  "failedStep": "dispatch-downstream",
  "compensations": [
    "revert-enrichment",
    "cancel-dispatch"
  ],
  "emittedEvent": "orchestration.processing.failed.v1"
}
```

These examples align with the current end-to-end controller coverage.