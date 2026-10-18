locals {
  stack   = yamldecode(file("${var.project}/stack.yaml"))
  grafana = local.stack.apps.grafana
  host    = cidrhost(local.stack.network.cidr, 1)

  # Mimir and Loki by their Consul names (the apps' job names), resolved through
  # the platform's Consul DNS: found wherever they run — in the mesh by their mesh
  # names, through Envoy. stack.yaml can name others.
  mesh       = try(local.grafana.mesh, {})
  in_mesh    = try(local.mesh.enabled, false)
  domain     = local.in_mesh ? "virtual.consul" : "service.consul"
  mimir_host = try(local.grafana.mimir_host, "mimir.${local.domain}")
  loki_host  = try(local.grafana.loki_host, "loki.${local.domain}")

  providers = jsondecode(var.damstack_providers)
  kinds = {
    "metrics@1" = { type = "prometheus", port = 9009, path = "/prometheus" }
    "logs@1"    = { type = "loki", port = 3100, path = "" }
  }
  connected = {
    for cap, k in local.kinds : cap => [
      for p in try(local.providers[cap], []) : {
        name = title(p.name)
        type = k.type
        url = format("http://%s:%d%s",
          local.in_mesh ? "${p.name}.virtual.consul" : (try(p.address, "") != "" ? p.address : "${p.name}.service.consul"),
          try(p.address, "") != "" ? try(p.port, k.port) : k.port,
          try(p.meta.path, try(p.address, "") != "" ? "" : k.path),
        )
      }
    ]
  }

  metrics = length(local.connected["metrics@1"]) > 0 ? local.connected["metrics@1"] : [
    { name = "Mimir", type = "prometheus", url = "http://${local.mimir_host}:${try(local.grafana.mimir_port, 9009)}/prometheus" },
  ]
  logs = length(local.connected["logs@1"]) > 0 ? local.connected["logs@1"] : [
    { name = "Loki", type = "loki", url = "http://${local.loki_host}:${try(local.grafana.loki_port, 3100)}" },
  ]

  datasources = concat(
    [for i, d in local.metrics : merge(d, { is_default = i == 0 })],
    local.logs,
  )
}

module "grafana" {
  source = "git::https://github.com/eugene-panin/terraform-nomad-grafana.git?ref=v0.2.0"

  hostname    = "grafana.service.consul"
  datasources = local.datasources
  dns_servers = try(local.grafana.dns_servers, [local.host])
  # The Consul service mesh, as a client: off unless stack.yaml turns it on
  # (mesh: {enabled}); allow grafana in Mimir's and Loki's intentions.
  mesh             = local.mesh
  anonymous_viewer = try(local.grafana.anonymous_viewer, true)
  vault_kv_path    = var.vault_kv_path
}

removed {
  from = vault_identity_oidc_client.grafana

  lifecycle {
    destroy = false
  }
}
