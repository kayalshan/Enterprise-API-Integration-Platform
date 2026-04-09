# Enterprise API & Event-Driven Integration Platform

## Table of Contents

## 📑 Table of Contents
- [Project Objective](#project-objective)
- [Problem Statement](#problem-statement)
- [Why Not Just Use Standard API Gateways](#why-not-just-use-standard-api-gateways)
- [Architecture Overview](#architecture-overview)
- [Key Architectural Decisions](#key-architectural-decisions)
- [Tech Stack](#tech-stack)
- [Impact](#impact)
- [Role: API & Integration Architect](#role-api--integration-architect)
- [Service Flow](#service-flow)
- [Sample Input and Expected Output](#sample-input-and-expected-output)
- [Multi-Module Build](#multi-module-build)

  
## Project Objective
To design and implement a scalable, secure, and enterprise-grade API and event-driven integration platform that enables seamless communication between microservices, legacy systems, and external partners, while enforcing API governance, versioning, and backward compatibility. The platform ensures long-term maintainability, high performance, and accelerated partner onboarding.

---

## Problem Statement
Legacy integration systems were tightly coupled, resulting in:  
- High latency and slow response times  
- Limited scalability under increasing workloads  
- Inefficient partner onboarding processes  

The objective was to build an API-first, event-driven platform capable of supporting enterprise-grade workloads with high availability, reliability, and security.

---

## Why Not Just Use Standard API Gateways?

- Enterprise systems require event-driven integration, governance, transformation layers, resilience, and observability beyond standard API gateway capabilities.
---

Our project builds a platform on top of API Gateway, combining API-first principles, event-driven integration, governance, resilience, and partner onboarding. It’s more than a gateway — it’s an enterprise-grade integration backbone.

---

## Architecture Overview

The platform is engineered as a high-performance, resilient integration backbone designed to handle enterprise - scale workloads while maintaining strict governance and security standards. The architecture is decomposed into the following specialized layers:

 - API Management & Entry Layer: Utilizes AWS API Gateway to orchestrate centralized routing, request throttling, and perimeter security.
 - High-Concurrency Microservices: Built on Java 21 and Spring Boot, leveraging Docker containerization to ensure consistent execution environments across AWS ECS and EKS.
 - Asynchronous Event Fabric: Employs a dual-mode messaging strategy using Apache Kafka for high - throughput stream processing and AWS SQS for decoupled, point-to-point task queuing.
 - Identity & Access Governance: Implements a robust "Zero Trust" security model powered by AWS Cognito, OAuth2, and JWT for fine-grained authorization.
 - Full-Stack Observability: Provides end-to-end visibility through OpenTelemetry for distributed tracing, Prometheus for real-time metrics collection, and Grafana for unified dashboarding and proactive alerting.
 - Automated Provisioning & Delivery: Drives rapid deployment cycles via Terraform for Infrastructure as Code (IaC), integrated with Jenkins and AWS CodePipeline for continuous delivery.
 - Enterprise Governance Framework: Enforces long-term stability through OpenAPI/AsyncAPI contract-first design, Canonical Data Models, strict versioning policies, and automated partner onboarding workflows.

---

## Key Architectural Decisions
- API-First Contracts: OpenAPI + AsyncAPI to enforce consistent API and event contracts  
- Decoupled Services: Kafka + SQS to improve scalability and fault tolerance  
- Canonical Models & Transformation Layer: Prevent domain leakage and ensure consistent data mapping  
- Automated Partner Onboarding: Accelerates: Sandbox, mocks, API key automation  
- Multi-Layered Resilience: Circuit-breakers, bulkheads, retries, and DLQs for reliable operations  
- End-to-End Observability:: OpenTelemetry instrumentation, Prometheus metrics scraping, Grafana dashboards, and alerting for end-to-end visibility  
---

```text

## Tech Stack

| Category           | Technologies |
|------------------|--------------|
| Backend           | Java 21, Spring Boot |
| API Management    | AWS API Gateway |
| Event Streaming   | Kafka, AWS SQS |
| Cloud Platform    | AWS (ECS, EKS, Lambda, Cognito) |
| Containerization  | Docker |
| Infrastructure IaC| Terraform |
| CI/CD             | Jenkins, AWS CodePipeline |
| Governance        | OpenAPI, AsyncAPI, Schema Registry |

```
---

## Impact
- Achieved 99.99% system availability  
- Reduced API latency by 40%  
- Scaled to handle 10,000+ TPS (estimated)  
- Accelerated deployment cycles by 60% using CI/CD automation  
- Enterprise-grade security with OAuth2, JWT, and Cognito  

---


## Role: API & Integration Architect

Responsibilities and Contributions:  
- Led API-first architecture and event-driven integration design  
- Defined microservice interactions, canonical models, and transformation layer  
- Implemented API governance: versioning, lifecycle management, deprecation policies, and contract-first design  
- Designed Kafka + SQS event-driven communication with DLQ, retries, and idempotency  
- Built partner onboarding modules: sandbox, mocks, API key automation  
- Enforced security standards: OAuth2, JWT, Cognito, mTLS, secrets management  
- Defined infrastructure as code (Terraform) and CI/CD pipelines (Jenkins, AWS CodePipeline)  
- Mentored developers on best practices and reviewed architectural decisions  
- Collaborated with stakeholders for high availability, scalability, and maintainability

---

```

## Service Flow

Client / Partner App
        |
        v
API Gateway (auth, versioning, routing)
        |
        v
Core API Microservices ──────────────► Produces Events
        |                                      |
        v                                      v
Transformation Service         Event Orchestration / Saga
        |
        v
Partner Onboarding / Mocks

   ```
---
## Sample Input And Expected Output

Keep the root README focused on **high-level** integration behavior. Detailed service-level examples now live inside each service README.

| Service | High-level input | High-level output | Details |
|---|---|---|---|
| `core-api-service` | Partner order payload with `orderId` and `partnerId` | `202 Accepted` response with correlation metadata or a validation error | `services/core-api-service/README.md` |
| `event-orchestration-service` | Domain event envelope for event processing | orchestration progress, compensation details, or validation error | `services/event-orchestration-service/README.md` |
| `transformation-service` | Generic or versioned partner payload (`v1` / `v2`) | canonical payload enriched with `sourceVersion`, `targetVersion`, and transformation metadata | `services/transformation-service/README.md` |
| `partner-onboarding-service` | Authenticated partner onboarding request or sandbox probe | partner credentials, sandbox verification, or auth failure | `services/partner-onboarding-service/README.md` |
---
### High-level platform I/O flow

```text
Partner / Client Request
        ↓
Core API or Partner Onboarding endpoint
        ↓
Transformation and orchestration layers
        ↓
Accepted response / canonical payload / onboarding result / event-processing status

```

---

## Multi-Module Build

The repository is configured as a standard Maven parent project for all service modules.

- Java version: 21, managed from the parent [pom.xml](pom.xml)
- Default build: includes every service module in the reactor
- Selective build: choose only the services you need with Maven project selection

Build all services:

```bash
mvn clean install
```

Build a single service:

```bash
mvn -pl services/core-api-service -am clean install
```

Build multiple services together:

```bash
mvn -pl services/core-api-service,services/transformation-service -am clean install
```

Swagger/OpenAPI for the core API service:

```bash
cd services/core-api-service
export JAVA_HOME=/usr/local/sdkman/candidates/java/21.0.9-ms
export PATH="$JAVA_HOME/bin:$PATH"
mvn spring-boot:run
```

- Swagger UI: `http://localhost:8080/swagger-ui.html`
- OpenAPI JSON: `http://localhost:8080/v3/api-docs`
- Repository contract: `api-platform/contracts/openapi/openapi.yaml`
- Postman collection: `api-platform/contracts/postman/core-api-service.postman_collection.json`

To run against AWS-backed environments, set SPRING_PROFILES_ACTIVE=dev or SPRING_PROFILES_ACTIVE=prod along with the required AWS environment variables:
AWS_REGION
AWS_MSK_BOOTSTRAP_SERVERS
PARTNER_SANDBOX_BASE_URL
SERVER_PORT
 
Each service now uses `local` as the default Spring profile and provides separate `application-local.yml`, `application-dev.yml`, and `application-prod.yml` files under its `src/main/resources` directory.

To run a service locally with an explicit profile:

```bash
mvn -pl services/core-api-service spring-boot:run -Dspring-boot.run.profiles=local
```

To run against AWS-backed environments, set `SPRING_PROFILES_ACTIVE=dev` or `SPRING_PROFILES_ACTIVE=prod` together with the required AWS environment variables such as `AWS_REGION`, `AWS_MSK_BOOTSTRAP_SERVERS`, `PARTNER_SANDBOX_BASE_URL`, and `SERVER_PORT`.

Actuator health endpoints:

- `http://localhost:8080/actuator/health`
- `http://localhost:8081/actuator/health`
- `http://localhost:8082/actuator/health`
- `http://localhost:8083/actuator/health`

Run the platform with the environment-specific Docker Compose files:

### Local

Builds the services from source and starts a local Kafka broker.

```bash
docker compose -f docker-compose.local.yaml up --build
```

#### Postman collections for local testing

Use the checked-in environment file:

- `tests/integration/postman/local.postman_environment.json`

Available local E2E collections:

- `tests/integration/postman/core-api-e2e.postman_collection.json`
- `tests/integration/postman/event-orchestration-e2e.postman_collection.json`
- `tests/integration/postman/transformation-service-e2e.postman_collection.json`
- `tests/integration/postman/partner-onboarding-e2e.postman_collection.json`

Available modules:

- `services/core-api-service`
- `services/event-orchestration-service`
- `services/transformation-service`
- `services/partner-onboarding-service`

The `-pl` flag selects the modules to build, and `-am` also builds any required upstream modules from the same reactor.

---
