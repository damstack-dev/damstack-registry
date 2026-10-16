locals {
  stack = yamldecode(file("${var.project}/stack.yaml"))
  nats  = local.stack.apps.nats
}

module "nats" {
  source = "git::https://github.com/eugene-panin/terraform-nomad-nats.git?ref=v0.1.4"

  users  = local.nats.users
  config = local.nats.config
  # The Consul service mesh: off unless stack.yaml turns it on (mesh: {enabled,
  # allow, keep_open_ports}).
  mesh          = try(local.nats.mesh, {})
  vault_kv_path = var.vault_kv_path
}
