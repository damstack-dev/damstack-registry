locals {
  stack      = yamldecode(file("${var.project}/stack.yaml"))
  cloudflare = local.stack.apps.cloudflare
  sets       = [for f in sort(fileset("${var.project}/dns", "*.json")) : jsondecode(file("${var.project}/dns/${f}"))]
}

module "cloudflare" {
  source = "git::https://github.com/eugene-panin/terraform-nomad-hashistack.git//modules/dns-cloudflare?ref=v1.0.0"

  records = local.sets
  zones   = local.cloudflare.zones
}

moved {
  from = module.cloudflare[0]
  to   = module.cloudflare
}
