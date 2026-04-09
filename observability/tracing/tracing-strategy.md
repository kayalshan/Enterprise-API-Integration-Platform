# Distributed Tracing Strategy

This platform uses **OpenTelemetry** to trace requests across gateway ingress, Kafka orchestration, transformation, and partner onboarding flows.

## Trace Propagation Rules

### HTTP
Propagate the following headers on every request:

- `traceparent`
- `tracestate`
- `X-Correlation-Id`
- `X-Request-Id`

### Kafka / Async Events
Copy these values into message headers:

- `traceparent`
- `tracestate`
- `correlationId`
- `eventId`
- `partnerId` when available

## Recommended Span Model

| Service | Span Name | Important Attributes |
|---|---|---|
| `core-api-service` | `POST /v1/orders` | `partner.id`, `resource.id`, `messaging.destination=orders.v1` |
| `event-orchestration-service` | `orchestrate event` | `event.id`, `event.type`, `retry.attempt`, `saga.failed_step` |
| `transformation-service` | `transform payload` | `source.system`, `source.version`, `target.version` |
| `partner-onboarding-service` | `POST /partners/onboard` | `partner.email`, `partner.id`, `security.auth.type=basic` |

## Events Worth Tracing

- request accepted
- event published to Kafka
- orchestration saga started
- retry scheduled
- compensation triggered
- event sent to DLQ
- payload transformation completed
- partner onboarded successfully

## Sampling Guidance

- **Local/dev:** `100%` trace sampling
- **Prod baseline:** `10%` sampling, with tail-based retention for errors and slow traces
- Always retain traces for:
  - HTTP `5xx`
  - DLQ publishes
  - compensation flows
  - authentication failures

## Naming & Correlation Standards

- Use the same `correlationId` from the ingress API through all downstream events.
- Attach `eventId`, `partnerId`, `resourceId`, and `attempt` as span attributes where applicable.
- Keep span names action-oriented, e.g. `publish order event`, `schedule retry`, `send to dlq`.

## Example End-to-End Flow

1. `core-api-service` receives `POST /v1/orders`
2. span records validation and publish to `orders.v1`
3. `event-orchestration-service` continues the same trace from Kafka headers
4. retry / compensation / DLQ spans appear as children of the orchestration span
5. Grafana Tempo / Jaeger shows the full request path for triage
