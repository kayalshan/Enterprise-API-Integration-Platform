# Cognito Security Overview

This folder defines the AWS Cognito baseline for the platform's **Zero Trust** identity and access model referenced in the root `README.md`.

## Scope

Cognito is the primary identity provider for:
- machine-to-machine access using OAuth2 client credentials
- JWT issuance and verification for platform APIs
- Cognito group-based authorization such as `PARTNER` and internal operator roles
- environment-specific user pool and app client isolation

## Folder Contents

- `cognito-setup.md` — overall Cognito baseline and deployment rules
- `user-pool/user-pool-configuration.md` — per-environment user pool guidance
- `resource-server/resource-server-scopes.md` — business scopes such as `orders.read` and `orders.write`
- `app-clients/m2m-app-clients.md` — confidential app clients for service-to-service access
- `token-management/token-lifecycle.md` — token lifetime, revocation, and rotation guidance

## Environment Strategy

| Environment | Source of truth | Expected usage |
|---|---|---|
| `local` | Spring Cloud Config | local issuer URI, mock user pool metadata, sample client configuration |
| `dev` | AWS Secrets Manager | dev user pool identifiers, app client secrets, issuer/JWKS settings |
| `prod` | AWS Secrets Manager | production user pool identifiers, app client secrets, issuer/JWKS settings |

## Recommended secret references

- `/enterprise-platform/local/cognito/*` → represented in Spring Cloud Config-backed properties for local development
- `/enterprise-platform/dev/cognito/user-pool`
- `/enterprise-platform/dev/cognito/app-client/partner-m2m`
- `/enterprise-platform/prod/cognito/user-pool`
- `/enterprise-platform/prod/cognito/app-client/partner-m2m`

## Operational rules

- Use a dedicated Cognito user pool per environment.
- Keep Cognito scopes aligned with API Gateway, OpenAPI, and Spring Security checks.
- Never commit real client secrets or pool identifiers into the repository.
- Grant partner apps only the minimum scopes and groups they require.
