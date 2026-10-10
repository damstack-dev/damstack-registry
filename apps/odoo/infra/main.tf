locals {
  stack = yamldecode(file("${var.project}/stack.yaml"))
  odoo  = local.stack.apps.odoo
}

module "odoo" {
  source = "git::https://github.com/eugene-panin/terraform-nomad-odoo.git?ref=v0.2.4"

  hostname   = local.odoo.hostname
  odoo_image = try(local.odoo.image, "odoo:19.0")
  postgres   = try(local.odoo.postgres, { mode = "bundled" })
  # The platform's Consul DNS on its first host, so postgres.host can be the
  # shared PostgreSQL's Consul name; it forwards the rest.
  dns_servers   = try(local.odoo.dns_servers, [cidrhost(local.stack.network.cidr, 1)])
  db_name       = try(local.odoo.db_name, "odoo")
  workers       = try(local.odoo.workers, 2)
  demo          = try(local.odoo.demo, false)
  vault_kv_path = var.vault_kv_path
}
