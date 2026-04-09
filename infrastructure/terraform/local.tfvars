environment               = "local"
aws_region                = "us-east-1"
service_name              = "core-api-service"
container_image           = "example/core-api-service:local"
container_port            = 8080
msk_bootstrap_servers     = "localhost:9092"
partner_sandbox_base_url  = "http://localhost:8083/sandbox/v1"

extra_env_vars = {
  MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE = "health,info"
}
