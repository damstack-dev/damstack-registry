output "host" {
  description = "Internal address clients connect to: the platform's first host, where Loki binds."
  value       = cidrhost(local.stack.network.cidr, 1)
}

output "http_port" {
  description = "Port Loki serves its HTTP API on."
  value       = module.loki.http_port
}

output "service_name" {
  description = "Consul service name of Loki."
  value       = module.loki.service_name
}
