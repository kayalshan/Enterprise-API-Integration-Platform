# Infrastructure Environment Profiles

This Terraform folder is organized around three runtime targets:

- `local` — developer runtime, local Docker Compose and localhost dependencies
- `dev` — shared AWS-backed development environment
- `prod` — production AWS environment with higher scale and retention

## Files

- `main.tf` — common environment-aware Terraform scaffold
- `local.tfvars` — example local values
- `dev.tfvars` — example development values
- `prod.tfvars` — example production values

## Usage

```bash
cd infrastructure/terraform
terraform init
terraform plan -var-file=local.tfvars
terraform plan -var-file=dev.tfvars
terraform plan -var-file=prod.tfvars
```

## Notes

- Local uses `SPRING_PROFILES_ACTIVE=local`
- Dev uses `SPRING_PROFILES_ACTIVE=dev`
- Prod uses `SPRING_PROFILES_ACTIVE=prod`
- Replace the example ECR image URIs, MSK brokers, VPC IDs, and IAM role ARNs with real environment values before apply
