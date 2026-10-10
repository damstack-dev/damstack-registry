mock_provider "consul" {}
mock_provider "nomad" {}

variables {
  state_passphrase = "a passphrase for the test only"
}

run "it_exposes_the_connection_consumers_need" {
  command = apply

  assert {
    condition     = output.host == "10.77.0.1"
    error_message = "The host is not the platform's first host."
  }

  assert {
    condition     = output.http_port == 3100
    error_message = "The port is not the Loki HTTP port."
  }

  assert {
    condition     = output.service_name == "loki"
    error_message = "The Consul service is not loki."
  }
}
