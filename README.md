# Enterprise API & Event-Driven Integration Platform

A high-performance, resilient integration backbone featuring **API-first governance**, **event-driven orchestration**, and **automated partner onboarding** built with **Java 21** and **AWS**.

---

## Architectural Vision
This platform serves as an enterprise-grade integration layer designed to decouple microservices from legacy systems while enforcing strict security and governance. Unlike standard API Gateways, this system provides a specialized fabric for:

* **Dual-Mode Messaging Strategy**: Utilizes **Apache Kafka** for high-throughput stream processing and **AWS SQS** for decoupled, point-to-point task queuing.
* **Distributed Resilience**: Implementation of **Saga patterns**, Circuit Breakers, and DLQs to ensure 99.99% availability.
* **Canonical Data Modeling**: Preventing domain leakage by enforcing standardized transformation layers across all integrations.
* **Zero-Trust Security**: Fine-grained authorization via **AWS Cognito**, **OAuth2**, and **JWT**.

---

## Tech Stack
* **Backend**: Java 21, Spring Boot 3.x.
* **Messaging**: Apache Kafka (Event Fabric), AWS SQS (Task Queuing).
* **Cloud & Infrastructure**: AWS (API Gateway, ECS, EKS, Lambda, Cognito), Terraform.
* **Observability**: OpenTelemetry, Prometheus, Grafana.
* **Governance**: OpenAPI 3.0, AsyncAPI, Schema Registry.

---

## Repository Structure
This repo is structured as a **Technical Case Study**. It contains architecture manifests, contract definitions, and pattern samples rather than the full proprietary source code.

```text
├── api-platform/          # OpenAPI/AsyncAPI contracts & Gateway policies
├── deployments/           # K8s manifests (Kustomize) & ECS configurations
├── infrastructure/        # Terraform IaC modules
├── resilience/            # Pattern samples for Bulkheads & Circuit Breakers
├── services/              # Module stubs (Core API, Event Orchestration, Transformation, Onboarding)
└── tests/                 # Postman E2E suites & Newman integration
```
---

## Architect Contributions  
* **Designed the Event-Driven Architecture and Saga-based orchestration for multi-service transactions.
* **Defined the API Governance framework, including versioning policies and backward compatibility checks.
* **Led the implementation of Infrastructure as Code (IaC) using Terraform for multi-region AWS deployments.
* **Developed the Automated Partner Onboarding module to streamline external vendor integration.

---

## Technical Achievements 

* **Throughput: Managed 10k+ requests per second with <200ms latency.
* **Resiliency: Implemented Circuit Breakers (Resilience4j) resulting in 99.9% uptime during downstream vendor outages.
* **Automation: Reduced partner onboarding time from 2 weeks to 2 hours via a modular integration engine.
---
