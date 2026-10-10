locals {
  stack     = yamldecode(file("${var.project}/stack.yaml"))
  seaweedfs = local.stack.apps.seaweedfs
}

module "seaweedfs" {
  source = "git::https://github.com/eugene-panin/terraform-nomad-seaweedfs.git?ref=v0.1.1"

  bucket        = try(local.seaweedfs.bucket, "lake")
  identities    = local.seaweedfs.identities
  vault_kv_path = var.vault_kv_path
}
