# Transformation Service

Spring Boot service for transforming external partner payloads (`v1`, `v2`, and partner-specific formats) into a shared internal `CanonicalRequest` model.

## Integration flow

```text
External Request (V1 / V2 / Partner Format)
            ↓
      Transformation
            ↓
Canonical Request (INTERNAL MODEL)
            ↓
       Sent to:
       - Core Service
       - Kafka Events
       - Orchestration
```

## Working folder structure

```text
services/transformation-service/
├── src/main/java/com/company/transformation/
│   ├── TransformationServiceApplication.java
│   ├── config/
│   │   └── TransformationProperties.java
│   ├── controller/
│   │   └── TransformationController.java
│   ├── engine/
│   │   └── TransformationEngine.java
│   ├── enrichment/
│   │   ├── EnrichmentPipeline.java
│   │   └── EnrichmentService.java
│   ├── exception/
│   │   ├── TransformationException.java
│   │   └── TransformationExceptionHandler.java
│   ├── mapper/
│   │   └── TransformationMapper.java
│   ├── model/
│   │   ├── TransformationRequest.java
│   │   ├── TransformationResponse.java
│   │   ├── canonical/
│   │   │   ├── CanonicalPayload.java
│   │   │   └── CanonicalRequest.java
│   │   ├── v1/
│   │   │   └── TransformationV1Request.java
│   │   └── v2/
│   │       └── TransformationV2Request.java
│   ├── service/
│   │   └── TransformationService.java
│   ├── strategy/
│   │   ├── StrategyFactory.java
│   │   ├── TransformationStrategy.java
│   │   ├── V1TransformationStrategy.java
│   │   └── V2TransformationStrategy.java
│   └── validation/
│       └── RequestValidator.java
├── src/main/resources/
│   ├── application.yml
│   ├── application-local.yml
│   ├── application-dev.yml
│   └── application-prod.yml
├── src/test/java/com/company/transformation/
│   ├── TransformationServiceApplicationTest.java
│   ├── controller/
│   │   └── TransformationControllerE2ETest.java
│   ├── enrichment/
│   │   └── EnrichmentServiceTest.java
│   ├── mapper/
│   │   └── TransformationMapperTest.java
│   └── service/
│       └── TransformationServiceTest.java
├── Dockerfile
├── pom.xml
└── README.md
```

## Endpoints

- `POST /api/transformations` — generic transformation endpoint for normalized payloads
- `POST /api/transformations/v1` — transform external `TransformationV1Request` into internal canonical format
- `POST /api/transformations/v2` — transform external `TransformationV2Request` into internal canonical format

## Run locally

```bash
export JAVA_HOME=/usr/local/sdkman/candidates/java/21.0.9-ms
export PATH="$JAVA_HOME/bin:$PATH"
mvn -f services/transformation-service/pom.xml spring-boot:run
```

## Sample Input And Expected Output

### Generic transformation request

Request:

```json
{
  "sourceSystem": "partner-portal",
  "version": "v1",
  "payload": {
    "partnerId": "P-1001",
    "partnerName": "Acme Supplies",
    "contactEmail": "ops@acme.example"
  }
}
```

Expected response (`200 OK`):

```json
{
  "status": "SUCCESS",
  "targetVersion": "v2",
  "canonicalPayload": {
    "sourceSystem": "partner-portal",
    "schemaVersion": "v2",
    "attributes": {
      "partnerId": "P-1001",
      "partnerName": "Acme Supplies",
      "contactEmail": "ops@acme.example",
      "sourceVersion": "v1",
      "targetVersion": "v2",
      "enrichmentStatus": "applied"
    }
  }
}
```

### Version-specific inputs

- `POST /api/transformations/v1` accepts `partnerId`, `partnerName`, and `contactEmail`
- `POST /api/transformations/v2` accepts `partnerId`, `displayName`, `contactEmail`, and `region`
- both versioned endpoints return a `CanonicalRequest` envelope with `status`, `sourceVersion`, `targetVersion`, and `canonicalPayload`

These examples align with the current controller e2e tests and canonical contract.
