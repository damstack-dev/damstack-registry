output "dns_records" {
  description = "DNS records of the webmail host names; a domain module of the project publishes them."
  value = {
    for h in local.webmail.hostnames : h => [
      { type = "A", name = h, content = var.server_address, priority = null, comment = "Webmail" },
    ]
  }
}

output "urls" {
  description = "URLs the webmail is served on."
  value       = module.webmail.urls
}

output "jmap_url" {
  description = "The JMAP server the webmail signs in to."
  value       = local.jmap_url
}
