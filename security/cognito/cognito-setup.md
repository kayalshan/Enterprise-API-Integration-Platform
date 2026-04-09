# Cognito Setup

This directory contains the AWS Cognito security baseline for the platform described in the root `README.md`.

## Structure

- `user-pool/`: user pool baseline and identity configuration guidance
- `resource-server/`: resource server definitions and scope design rules
- `app-clients/`: machine-to-machine app client configuration standards
- `token-management/`: token revocation, rotation, and lifecycle controls

## Environment source of truth

| Environment | Configuration source | Notes |
|---|---|---|
| `local` | Spring Cloud Config | use config-backed local issuer URIs, app client placeholders, and mock JWKS settings |
| `dev` | AWS Secrets Manager | store real user pool ids, app client secrets, issuer URIs, and integration values |
| `prod` | AWS Secrets Manager | store production user pool ids, secrets, and hardened token settings |

## Documents

- `README.md`
- `user-pool/user-pool-configuration.md`
- `resource-server/resource-server-scopes.md`
- `app-clients/m2m-app-clients.md`
- `token-management/token-lifecycle.md`

## Core Requirements

- Define resource servers and scopes before onboarding clients.
- Configure confidential app clients for machine-to-machine authentication.
- Enable token revocation and apply token lifetime controls.
- Keep Cognito configuration aligned with the OAuth2 and JWT security policies.
- Never commit real Cognito secrets or pool identifiers into the repository.
- Isolate user pools and client secrets by environment.
