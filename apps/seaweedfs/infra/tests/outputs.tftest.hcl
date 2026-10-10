mock_provider "consul" {}
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
    condition     = output.s3_port == 8333
    error_message = "The S3 port is not the SeaweedFS port."
  }

  assert {
    condition     = output.keys_secret == "default/seaweedfs/keys"
    error_message = "The secret keys are not at the expected Vault name."
  }
}
