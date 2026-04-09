# Core API Service

Spring Boot service exposing the primary core API endpoints for order intake, validation, persistence, and event publishing.

## Working folder structure

```text
services/core-api-service/
├── src/main/java/com/company/coreapi/
│   ├── CoreApiApplication.java
│   ├── config/
│   │   ├── CoreApiConfig.java
│   │   └── OpenApiConfiguration.java
│   ├── controller/
│   │   ├── ApiExceptionHandler.java
│   │   └── CoreApiController.java
│   ├── event/
│   │   └── CoreApiEventPublisher.java
│   ├── model/
│   │   ├── ApiErrorResponse.java
│   │   ├── CanonicalOrder.java
│   │   ├── CreateOrderRequest.java
│   │   └── CreateOrderResponse.java
│   ├── repository/
│   │   └── IntegrationRepository.java
│   └── service/
│       └── IntegrationService.java
├── src/test/java/com/company/coreapi/
│   ├── controller/
│   │   └── CoreApiControllerTest.java
│   ├── event/
│   │   └── CoreApiEventPublisherTest.java
│   └── service/
│       └── IntegrationServiceTest.java
├── src/main/resources/
├── Dockerfile
├── pom.xml
└── README.md
```

## Responsibilities

- Expose core REST endpoints
- Validate incoming order requests
- Persist/integrate with downstream components
- Publish integration events

## Run locally

```bash
export JAVA_HOME=/usr/local/sdkman/candidates/java/21.0.9-ms
export PATH="$JAVA_HOME/bin:$PATH"
mvn -f services/core-api-service/pom.xml spring-boot:run
```

## Sample Input And Expected Output

### Create order — success path

Request:

```json
{
  "orderId": "ORD-1001",
  "partnerId": "partner-sandbox"
}
```

Expected response (`202 Accepted`):

```json
{
  "orderId": "ORD-1001",
  "partnerId": "partner-sandbox",
  "integrationStatus": "ACCEPTED",
  "correlationId": "<generated-uuid>",
  "acceptedAt": "<timestamp>",
  "nextStep": "Order accepted for downstream event orchestration"
}
```

### Create order — validation error

Request:

```json
{
  "orderId": "ORD-1002",
  "partnerId": ""
}
```

Expected response (`400 Bad Request`):

```json
{
  "code": "VALIDATION_ERROR",
  "message": "Request validation failed",
  "details": [
    "partnerId: partnerId is required"
  ]
}
```

These examples align with the current controller tests and the checked-in OpenAPI contract.

# Enhancement 

## Seccurity Fix #1:
```text

FINAL SECURITY FLOW 

Client
  ↓
JWT Token
  ↓
Spring Security Filter
  ↓
JwtDecoder (issuer-uri)
  ↓
JwtAuthConverter
  ↓
Authorities Created
  ↓
SecurityConfig Match
  ↓
Controller Access
```

