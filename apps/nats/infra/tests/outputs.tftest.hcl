mock_provider "nomad" {}
mock_provider "vault" {}
mock_provider "random" {}

variables {
  state_passphrase = "a passphrase for the test only"
  vault_kv_path    = "secret"
}

run "it_exposes_the_connection_consumers_need" {
  command = apply

  assert {
    condition     = output.host == "10.77.0.1"
    error_message = "The host is not the platform's first host."
  }

  assert {
    condition     = output.client_port == 4222
    error_message = "The client port is not the NATS port."
  }

  assert {
    condition     = output.credentials_secret == "default/nats/users"
    error_message = "The credentials are not at the expected Vault name."
  }
}
