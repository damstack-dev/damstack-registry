locals {
  stack     = yamldecode(file("${var.project}/stack.yaml"))
  seaweedfs = local.stack.apps.seaweedfs
}

module "seaweedfs" {
  source = "git::https://github.com/eugene-panin/terraform-nomad-seaweedfs.git?ref=v0.1.2"

  bucket     = try(local.seaweedfs.bucket, "lake")
  identities = local.seaweedfs.identities
  # The Consul service mesh: off unless stack.yaml turns it on (mesh: {enabled,
  # allow, keep_open_ports}).
  mesh          = try(local.seaweedfs.mesh, {})
  vault_kv_path = var.vault_kv_path
}
