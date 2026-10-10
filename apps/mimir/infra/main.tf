locals {
  stack = yamldecode(file("${var.project}/stack.yaml"))
  mimir = local.stack.apps.mimir
}

module "mimir" {
  source = "git::https://github.com/eugene-panin/terraform-nomad-mimir.git?ref=v0.1.2"

  retention_period = try(local.mimir.retention_period, "0s")
  # The Consul service mesh: off unless stack.yaml turns it on (mesh: {enabled,
  # allow}).
  mesh = try(local.mimir.mesh, {})
}
