terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "project_name" {
  type    = string
  default = "enterprise-api-integration-platform"
}

variable "environment" {
  type    = string
  default = "dev"

  validation {
    condition     = contains(["local", "dev", "prod"], var.environment)
    error_message = "environment must be one of: local, dev, prod."
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "service_name" {
  type    = string
  default = "core-api-service"
}

variable "container_image" {
  type    = string
  default = "example/core-api-service:latest"
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "private_subnet_ids" {
  type    = list(string)
  default = []
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "task_execution_role_arn" {
  type    = string
  default = ""
}

variable "task_role_arn" {
  type    = string
  default = ""
}

variable "msk_bootstrap_servers" {
  type    = string
  default = "localhost:9092"
}

variable "partner_sandbox_base_url" {
  type    = string
  default = "http://localhost:8083/sandbox/v1"
}

variable "extra_env_vars" {
  type        = map(string)
  default     = {}
  description = "Non-sensitive environment variables that are safe to expose in plans and outputs."

  validation {
    condition = length([
      for key in keys(var.extra_env_vars) : key
      if can(regex("(PASSWORD|SECRET|TOKEN|PRIVATE_KEY|API_KEY)", upper(key)))
    ]) == 0
    error_message = "Do not place secrets in extra_env_vars. Use secret_env_vars or a secrets manager reference instead."
  }
}

variable "secret_env_vars" {
  type        = map(string)
  default     = {}
  sensitive   = true
  description = "Sensitive environment variables. Supply these via ignored tfvars, environment variables, or your CI/CD secret store; never commit real values."
}

locals {
  environment_profiles = {
    local = {
      spring_profile     = "local"
      desired_count      = 1
      cpu                = 512
      memory             = 1024
      log_retention_days = 7
      domain_suffix      = "local"
    }
    dev = {
      spring_profile     = "dev"
      desired_count      = 2
      cpu                = 1024
      memory             = 2048
      log_retention_days = 14
      domain_suffix      = "dev.example.internal"
    }
    prod = {
      spring_profile     = "prod"
      desired_count      = 3
      cpu                = 2048
      memory             = 4096
      log_retention_days = 30
      domain_suffix      = "prod.example.internal"
    }
  }

  selected_profile = local.environment_profiles[var.environment]

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Service     = var.service_name
  }

  container_environment = merge(
    {
      SPRING_PROFILES_ACTIVE    = local.selected_profile.spring_profile
      SERVER_PORT               = tostring(var.container_port)
      AWS_REGION                = var.aws_region
      AWS_MSK_BOOTSTRAP_SERVERS = var.msk_bootstrap_servers
      PARTNER_SANDBOX_BASE_URL  = var.partner_sandbox_base_url
    },
    var.extra_env_vars,
    var.secret_env_vars
  )

  sanitized_container_environment = merge(
    {
      SPRING_PROFILES_ACTIVE    = local.selected_profile.spring_profile
      SERVER_PORT               = tostring(var.container_port)
      AWS_REGION                = var.aws_region
      AWS_MSK_BOOTSTRAP_SERVERS = var.msk_bootstrap_servers
      PARTNER_SANDBOX_BASE_URL  = var.partner_sandbox_base_url
    },
    var.extra_env_vars,
    {
      for key in keys(var.secret_env_vars) : key => "REDACTED"
    }
  )
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

output "environment_plan" {
  description = "Environment-aware deployment settings preview. Contains no secret values."
  value = {
    environment              = var.environment
    spring_profile           = local.selected_profile.spring_profile
    desired_count            = local.selected_profile.desired_count
    cpu                      = local.selected_profile.cpu
    memory                   = local.selected_profile.memory
    container_image          = var.container_image
    container_port           = var.container_port
    msk_bootstrap_servers    = var.msk_bootstrap_servers
    partner_sandbox_base_url = var.partner_sandbox_base_url
    domain_suffix            = local.selected_profile.domain_suffix
  }
}

output "container_environment" {
  description = "Sanitized preview of runtime environment variables. Sensitive values are redacted."
  value       = local.sanitized_container_environment
}

output "secret_env_var_names" {
  description = "Names of sensitive runtime variables configured for this environment."
  value       = sort(keys(var.secret_env_vars))
}

output "plan_commands" {
  value = {
    local = "terraform plan -var-file=local.tfvars"
    dev   = "terraform plan -var-file=dev.tfvars"
    prod  = "terraform plan -var-file=prod.tfvars"
  }
}
