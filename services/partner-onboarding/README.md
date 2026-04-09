# Partner Onboarding Service

## Overview

The Partner Onboarding Service is a mission-critical component of the Enterprise API & Integration Platform. It provides a standardized, secure, and automated workflow for internal and external partners to register, obtain credentials, and validate their integrations within a controlled sandbox environment.

By abstracting partner lifecycle management, this service ensures API consumption is governed, scalable, and aligned with enterprise security and compliance standards.

---

## Architecture & Logical Flow

The service acts as the controlled entry point into the API ecosystem, bridging partner onboarding with governed API access.

- **Identity Verification**  
  Validates partner metadata and business context before onboarding.

- **Credential Provisioning**  
  Generates unique partner identifiers and secure API keys.

- **Governance Injection**  
  Associates partners with access tiers, rate limits, and policies.

- **Sandbox Isolation**  
  Routes initial partner traffic to mock/sandbox endpoints to prevent production data exposure.

---

## Objectives

- **Seamless Self-Service**  
  Automate onboarding to minimize manual intervention.

- **Credential Governance**  
  Centralize API key issuance and lifecycle management.

- **Risk Mitigation**  
  Enable safe integration testing through sandbox isolation.

- **Auditability**  
  Maintain traceable records for compliance and monitoring.

---

## Key Capabilities

### Partner Registration & Lifecycle
- Capture partner metadata and assign persistent Partner ID  
- Manage lifecycle states: `PENDING`, `ACTIVE`, `SUSPENDED`, `INACTIVE`  

### API Key Management
- Generate entropy-rich API keys  
- Designed for key rotation, expiry, and revocation  
- Extensible to OAuth2 / OIDC integration  

### Sandbox Environment
- High-fidelity mock APIs simulating production behavior  
- Enables testing of edge cases and failure scenarios  

### Extensible Security Layer
- Designed for integration with API Gateways (Kong, Apigee, AWS API Gateway)  
- Supports policy enforcement (rate limiting, quotas, access tiers)  

---

## High-Level Flow
Partner → Onboarding Service → API Key Generated
       → Uses API Gateway → Core API Platform
       → Sandbox used for testing before production access

---

## Role in Platform Architecture

- Acts as the **entry point for partner enablement**
- Integrates with:
  - API Gateway (authentication, throttling, routing)
  - Core API Services (business processing)
  - Event Orchestration Service (async workflows)
  - Transformation Layer (canonical model mapping)

---

## Technology Stack

- Java 21  
- Spring Boot  
- Spring Data JPA  
- H2 (local) / PostgreSQL (production)  
- Docker  

---

## Project Structure

```text
partner-onboarding-service/
├── src/main/java/com/company/partner/
│ ├── PartnerOnboardingApplication.java
│ ├── controller/
│ ├── model/
│ ├── repository/
│ ├── security/
│ ├── service/
│ └── sandbox/
├── src/main/resources/
│ ├── application.yml
│ ├── application-local.yml
│ ├── application-dev.yml
│ └── application-prod.yml
├── Dockerfile
├── pom.xml
└── tests/
```

## API key generation and security utilities  

- **sandbox/**  
  Mock endpoints for integration testing  

---

## Runtime Configuration

- Default Port: `8083`  
- Sandbox Base URL: `http://localhost:8083/sandbox/v1`  
- Supported Profiles: `local`, `dev`, `prod`  

## API Contract Assets

- OpenAPI contract: `api-platform/openapi/partner-onboarding-service.yaml`
- Postman collection: `api-platform/postman/partner-onboarding-service.postman_collection.json`
- Runtime OpenAPI JSON: `http://localhost:8083/v3/api-docs`
- Swagger UI: `http://localhost:8083/swagger-ui.html`

The service currently uses default Spring Security basic authentication. In local development the username defaults to `user`, and the generated password is printed in the startup log unless you override it with explicit Spring Security properties.

---

## Build & Run
  API key generation and security utilities  

- **sandbox/**  
  Mock endpoints for integration testing  

---

## Runtime Configuration

- Default Port: `8083`  
- Sandbox Base URL: `http://localhost:8083/sandbox/v1`  
- Supported Profiles: `local`, `dev`, `prod`  

---

## Security & Compliance
- TLS 1.3 enforced for all communications
- API keys stored securely (hashed/masked)
- Secrets externalized (designed for vault integration)
- Supports future integration with enterprise IAM systems

## Design Considerations
- Lightweight onboarding for faster partner enablement
- Clear separation between sandbox and production flows
- Extensible security model for enterprise integration
- Designed to integrate with event-driven architecture

## Future Enhancements
- API Key validation filter
- Rate limiting and throttling
- Partner usage analytics
- OAuth2 / JWT integration
- API Gateway policy enforcement
- Multi-tenant partner isolation

## Conclusion

The Partner Onboarding Service establishes a secure and scalable foundation for partner integration. It enables controlled API access, enforces governance, and accelerates onboarding, making it a key pillar in the enterprise integration platform.

## Sample Input And Expected Output

### Partner onboarding request

Request:

```json
{
  "name": "Acme Retail",
  "email": "integration@acme.example"
}
```

Expected response (`200 OK`, with basic auth):

```json
{
  "partnerId": "<generated-uuid>",
  "name": "Acme Retail",
  "email": "integration@acme.example",
  "apiKey": "<generated-api-key>",
  "status": "ACTIVE"
}
```

### Sandbox verification

Request:

```http
GET /sandbox/test
Authorization: Basic <credentials>
```

Expected response:

```text
Sandbox API is working at /sandbox/v1
```

### Missing credentials

Expected response:

```http
401 Unauthorized
```

These examples align with the current controller tests and the runtime OpenAPI contract.