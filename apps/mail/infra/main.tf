locals {
  stack = yamldecode(file("${var.project}/stack.yaml"))
  mail  = local.stack.apps.mail
}

module "mail" {
  source = "git::https://github.com/eugene-panin/terraform-nomad-stalwart.git?ref=v0.4.0"

  hostname        = local.mail.hostname
  domains         = local.mail.domains
  mailboxes       = try(local.mail.mailboxes, ["info"])
  acme_email      = local.mail.acme_email
  permissive_cors = try(local.mail.permissive_cors, false)
  vault_kv_path   = var.vault_kv_path
}
