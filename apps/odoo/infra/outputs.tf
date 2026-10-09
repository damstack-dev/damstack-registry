output "dns_records" {
  description = "DNS record of the Odoo host name; the platform publishes it."
  value = {
    (local.odoo.hostname) = [
      { type = "A", name = local.odoo.hostname, content = var.server_address, priority = null, comment = "Odoo" },
    ]
  }
}

output "url" {
  description = "URL Odoo is served on."
  value       = module.odoo.url
}

output "admin_password" {
  description = "Odoo master password for the database manager."
  value       = module.odoo.admin_password
  sensitive   = true
}
