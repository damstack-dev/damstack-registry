output "host" {
  description = "Internal address clients connect to: the platform's first host, where NATS binds."
  value       = cidrhost(local.stack.network.cidr, 1)
}

output "client_port" {
  description = "Port NATS serves clients on."
  value       = module.nats.client_port
}

output "service_name" {
  description = "Consul service name of NATS."
  value       = module.nats.service_name
}

output "credentials_secret" {
  description = "Vault KV name (under the mount) holding each user's password; a client reads its own from here."
  value       = module.nats.credentials_secret
}
