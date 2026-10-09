output "host" {
  description = "Internal address clients connect to: the platform's first host, where Mimir binds."
  value       = cidrhost(local.stack.network.cidr, 1)
}

output "http_port" {
  description = "Port Mimir serves its HTTP API on."
  value       = module.mimir.http_port
}

output "service_name" {
  description = "Consul service name of Mimir."
  value       = module.mimir.service_name
}
