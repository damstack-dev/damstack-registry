locals {
  stack   = yamldecode(file("${var.project}/stack.yaml"))
  webmail = local.stack.apps.webmail
  mail    = try(local.stack.apps.mail, {})
  jmap_url = coalesce(
    try(local.webmail.jmap_url, null),
    try("https://${local.mail.hostname}", null),
  )
}

module "webmail" {
  source = "git::https://github.com/damstack-dev/terraform-nomad-bulwark.git?ref=v0.1.0"

  hostnames         = local.webmail.hostnames
  jmap_url          = local.jmap_url
  app_name          = try(local.webmail.app_name, null)
  image             = try(local.webmail.image, null)
  stalwart_features = try(local.webmail.stalwart_features, null)
  vault_kv_path     = var.vault_kv_path
}
