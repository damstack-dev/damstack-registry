locals {
  stack = yamldecode(file("${var.project}/stack.yaml"))
  loki  = local.stack.apps.loki
}

module "loki" {
  source = "git::https://github.com/eugene-panin/terraform-nomad-loki.git?ref=v0.1.1"

  retention_period = try(local.loki.retention_period, "168h")
}
