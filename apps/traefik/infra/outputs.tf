output "job_id" {
  description = "ID of the public Traefik job in Nomad."
  value       = module.traefik.job_id
}

output "entrypoints" {
  description = "Entrypoints a public app's router names: public-https, and public-http that redirects to it."
  value       = module.traefik.entrypoints
}

output "certresolver" {
  description = "Certificate resolver a router on public-https names for its certificate from Let's Encrypt."
  value       = module.traefik.certresolver
}

output "servers_transport" {
  description = "TCP servers transport that sends the PROXY protocol header, for TLS passthrough on public-https."
  value       = module.traefik.servers_transport
}

output "acme_volume" {
  description = "Host volume holding the ACME account and the certificates."
  value       = module.traefik.acme_volume
}

output "service_name" {
  description = "Consul service of the public Traefik."
  value       = module.traefik.service_name
}
