output "host" {
  description = "Internal address consumers connect to: the platform's first host, where PostgreSQL binds."
  value       = cidrhost(local.stack.network.cidr, 1)
}

output "port" {
  description = "Port PostgreSQL listens on."
  value       = module.postgres.port
}

output "service_name" {
  description = "Consul service name of PostgreSQL."
  value       = module.postgres.service_name
}

output "admin_secret" {
  description = "Vault KV name (under the mount) of the superuser credential a consumer reads to make its own database."
  value       = module.postgres.admin_secret
}

output "admin_password" {
  description = "Password of the PostgreSQL superuser."
  value       = module.postgres.admin_password
  sensitive   = true
}
