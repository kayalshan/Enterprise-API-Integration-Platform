# Producer Standards

- Attach `correlationId`, `traceId`, and schema version headers.
- Publish only validated events registered in schema registry.
- Use idempotency keys for retry-safe publishing.
