# OAuth2 Security Overview

This folder defines the OAuth2 patterns used by the platform for API and service authentication.

## Primary flow

The platform uses **client credentials** for machine-to-machine integrations, with AWS Cognito acting as the authorization server.

## Scope model

- `orders.read`
- `orders.write`
- additional scopes may be added only through API governance review

## Environment strategy

| Environment | Configuration source | Typical settings |
|---|---|---|
| `local` | Spring Cloud Config | local token endpoint, client id, client secret, scope defaults |
| `dev` | AWS Secrets Manager | dev token endpoint, client credentials, audience values |
| `prod` | AWS Secrets Manager | production token endpoint, client credentials, hardened token settings |

## Design rules

- least-privilege scopes only
- confidential clients for backend systems
- no interactive flows for internal machine integrations unless explicitly approved
- keep OAuth2 scopes aligned with Spring Security and OpenAPI contracts

See `oauth2-config.md` for the baseline configuration details.
