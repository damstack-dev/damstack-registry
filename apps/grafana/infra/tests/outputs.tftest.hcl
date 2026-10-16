mock_provider "consul" {}
mock_provider "nomad" {}
mock_provider "vault" {}
mock_provider "random" {}

variables {
  state_passphrase = "a passphrase for the test only"
  vault_kv_path    = "secret"
}

run "it_serves_grafana_on_the_infra_domain" {
  command = apply

  assert {
    condition     = output.url == "https://grafana.infra.example.org"
    error_message = "Grafana is not served on grafana.<infra_domain>."
  }

  assert {
    condition     = output.service_name == "grafana"
    error_message = "The Consul service is not grafana."
  }

  assert {
    condition     = output.admin_secret == "default/grafana/admin"
    error_message = "The admin credential is not at the expected Vault name."
  }
}

run "without_providers_mimir_and_loki_as_before" {
  command = apply

  assert {
    condition = local.datasources == [
      { name = "Mimir", type = "prometheus", url = "http://mimir.service.consul:9009/prometheus", is_default = true },
      { name = "Loki", type = "loki", url = "http://loki.service.consul:3100" },
    ]
    error_message = "Without providers the data sources must be Mimir and Loki by their Consul names, Mimir the default."
  }
}

run "the_connected_providers_are_the_data_sources" {
  command = apply

  variables {
    damstack_providers = jsonencode({
      "metrics@1" = [
        { name = "mimir", address = "10.77.0.1", port = 9009, meta = { path = "/prometheus" } },
        { name = "prometheus", address = "10.77.0.2", port = 9090, meta = {} },
      ]
      "logs@1" = [{ name = "loki", address = "10.77.0.1", port = 3100, meta = {} }]
    })
  }

  assert {
    condition = local.datasources == [
      { name = "Mimir", type = "prometheus", url = "http://10.77.0.1:9009/prometheus", is_default = true },
      { name = "Prometheus", type = "prometheus", url = "http://10.77.0.2:9090", is_default = false },
      { name = "Loki", type = "loki", url = "http://10.77.0.1:3100" },
    ]
    error_message = "Each connected provider must be a data source at its address, port and path, the first metrics one the default."
  }
}

run "a_provider_known_by_name_only_is_reached_by_its_consul_name" {
  command = apply

  variables {
    damstack_providers = jsonencode({
      "metrics@1" = [{ name = "mimir", address = "", port = 0, meta = {} }]
      "logs@1"    = []
    })
  }

  assert {
    condition = local.datasources == [
      { name = "Mimir", type = "prometheus", url = "http://mimir.service.consul:9009/prometheus", is_default = true },
      { name = "Loki", type = "loki", url = "http://loki.service.consul:3100" },
    ]
    error_message = "A provider known by name only must be reached by its Consul name and default port, and logs without providers as before."
  }
}
