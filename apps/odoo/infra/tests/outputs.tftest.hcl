mock_provider "nomad" {}
mock_provider "vault" {}
mock_provider "random" {}

variables {
  state_passphrase = "a passphrase for the test only"
  vault_kv_path    = "secret"
  server_address   = "192.0.2.10"
}

run "the_host_name_points_at_the_server" {
  command = apply

  assert {
    condition = output.dns_records["odoo.example.org"] == [
      { type = "A", name = "odoo.example.org", content = "192.0.2.10", priority = null, comment = "Odoo" },
    ]
    error_message = "The Odoo host name does not point at the server."
  }
}

run "it_serves_on_https" {
  command = apply

  assert {
    condition     = output.url == "https://odoo.example.org"
    error_message = "Odoo is not served on its host name over HTTPS."
  }
}
