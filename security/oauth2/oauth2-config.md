# OAuth2 Configuration

## Baseline

- **Grant type:** `client_credentials`
- **Primary scopes:** `orders.read`, `orders.write`
- **Default token lifetime:** `15 minutes`
- **Authorization server:** AWS Cognito

## Environment policy

| Environment | Source | What is stored |
|---|---|---|
| `local` | Spring Cloud Config | local token endpoint, test client credentials, scope defaults |
| `dev` | AWS Secrets Manager | dev client id, client secret, token URL, audience values |
| `prod` | AWS Secrets Manager | prod client id, client secret, token URL, hardened access policies |

## Design rules

- Use confidential clients for backend-to-backend communication.
- Keep scopes aligned with OpenAPI contracts and Spring Security enforcement.
- Rotate client secrets regularly and after security incidents.
- Never place live client secrets in Git or plain ConfigMaps.
