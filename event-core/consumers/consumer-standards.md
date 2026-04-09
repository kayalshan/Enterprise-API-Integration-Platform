# Consumer Standards

- Validate event schema version before processing.
- Implement at-least-once safe handlers.
- On repeated failure, route to DLQ with failure reason.
