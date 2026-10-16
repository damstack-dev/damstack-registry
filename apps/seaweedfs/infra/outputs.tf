output "host" {
  description = "Internal address clients connect to: the platform's first host, where SeaweedFS binds."
  value       = cidrhost(local.stack.network.cidr, 1)
}

output "s3_port" {
  description = "Port the S3 API is served on."
  value       = module.seaweedfs.s3_port
}

output "service_name" {
  description = "Consul service name of the S3 API."
  value       = module.seaweedfs.service_name
}

output "bucket" {
  description = "The S3 bucket the identities are granted on."
  value       = module.seaweedfs.bucket
}

output "keys_secret" {
  description = "Vault KV name (under the mount) holding each identity's secret key; a client reads its own from here."
  value       = module.seaweedfs.keys_secret
}
