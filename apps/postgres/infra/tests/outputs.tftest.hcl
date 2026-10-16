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
    condition     = output.port == 5432
    error_message = "The port is not the PostgreSQL port."
  }

  assert {
    condition     = output.admin_secret == "default/postgres/admin"
    error_message = "The admin credential is not at the expected Vault name."
  }
}
