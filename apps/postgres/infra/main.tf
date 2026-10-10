locals {
  stack    = yamldecode(file("${var.project}/stack.yaml"))
  postgres = local.stack.apps.postgres
}

module "postgres" {
  source = "git::https://github.com/eugene-panin/terraform-nomad-postgres.git?ref=v0.1.1"

  image         = try(local.postgres.image, "postgres:16.10")
  admin_user    = try(local.postgres.admin_user, "postgres")
  port          = try(local.postgres.port, 5432)
  vault_kv_path = var.vault_kv_path
}
