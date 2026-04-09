# Metrics Catalog

This catalog defines the **minimum technical and business metrics** for the platform.

## Platform Metrics (Micrometer / Actuator)

| Metric | Type | Key Labels | Why it matters |
|---|---|---|---|
| `http_server_requests_seconds` | histogram | `application`, `method`, `uri`, `status` | API latency and error-rate SLOs |
| `jvm_memory_used_bytes` | gauge | `application`, `area`, `id` | JVM memory pressure |
| `jvm_threads_live_threads` | gauge | `application` | thread starvation signals |
| `process_cpu_usage` | gauge | `application` | CPU saturation |
| `logback_events_total` | counter | `application`, `level` | error/warn spikes |
| `kafka_consumer_fetch_manager_records_lag_max` | gauge | `spring_id`, `topic` | backlog and delayed consumption |

## Business Metrics by Domain

### Core API

| Metric | Type | Labels | Description |
|---|---|---|---|
| `integration_orders_received_total` | counter | `partnerId`, `status` | total accepted/rejected inbound orders |
| `integration_duplicate_orders_total` | counter | `partnerId` | idempotent duplicate detections |
| `integration_order_publish_latency_seconds` | timer | `topic` | time from API receipt to event publication |

### Event Orchestration

| Metric | Type | Labels | Description |
|---|---|---|---|
| `orchestration_saga_started_total` | counter | `eventType` | orchestration requests started |
| `orchestration_compensation_triggered_total` | counter | `failedStep` | compensation flow activations |
| `integration_retry_scheduled_total` | counter | `topic`, `attempt` | retry scheduling volume |
| `integration_dlq_published_total` | counter | `topic`, `errorCode` | DLQ events sent after retry exhaustion |
| `orchestration_step_duration_seconds` | timer | `stepName`, `outcome` | per-step latency in the saga |

### Transformation

| Metric | Type | Labels | Description |
|---|---|---|---|
| `transformation_requests_total` | counter | `sourceSystem`, `version`, `status` | total transformation requests |
| `transformation_duration_seconds` | timer | `sourceVersion`, `targetVersion` | mapping latency |
| `transformation_validation_failures_total` | counter | `reason` | payload/schema validation failures |

### Partner Onboarding

| Metric | Type | Labels | Description |
|---|---|---|---|
| `partner_onboarding_requests_total` | counter | `status` | total partner onboarding attempts |
| `partner_api_keys_generated_total` | counter | `partnerStatus` | API key provisioning activity |
| `sandbox_requests_total` | counter | `status` | partner sandbox usage and availability |

## Suggested SLOs

| Capability | Objective |
|---|---|
| Core API availability | `>= 99.9%` monthly |
| p95 API latency | `< 1.5s` for partner-facing endpoints |
| Event orchestration success without compensation | `>= 99%` |
| DLQ rate | `0` sustained; any burst should page the team |
| Partner onboarding response time | `< 2s` p95 |

## Instrumentation Notes

- Standard metrics come from **Spring Boot Actuator + Micrometer**.
- Custom counters/timers should be emitted at the service layer where business transitions occur.
- Always label metrics by **service**, **environment**, and **outcome** to support dashboards and alerts.
