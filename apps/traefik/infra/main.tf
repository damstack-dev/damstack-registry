locals {
  stack   = yamldecode(file("${var.project}/stack.yaml"))
  traefik = local.stack.apps.traefik
}

module "traefik" {
  source = "git::https://github.com/eugene-panin/terraform-nomad-hashistack.git//modules/traefik?ref=v1.0.0"

  role       = "public"
  acme_email = local.traefik.acme_email
  consul     = { ca_pem = file("${var.project}/ca.pem") }
}
