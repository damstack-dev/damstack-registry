locals {
  stack    = yamldecode(file("${var.project}/stack.yaml"))
  postgres = local.stack.apps.postgres
}

module "postgres" {
  source = "git::https://github.com/eugene-panin/terraform-nomad-postgres.git?ref=v0.1.3"

  image      = try(local.postgres.image, "postgres:16.10")
  admin_user = try(local.postgres.admin_user, "postgres")
  port       = try(local.postgres.port, 5432)
  # The Consul service mesh: off unless stack.yaml turns it on (mesh: {enabled,
  # allow, keep_open_ports}).
  mesh          = try(local.postgres.mesh, {})
  vault_kv_path = var.vault_kv_path
}
