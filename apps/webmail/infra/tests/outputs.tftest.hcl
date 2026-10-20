mock_provider "nomad" {}
mock_provider "vault" {}
mock_provider "random" {}

variables {
  state_passphrase = "a passphrase for the test only"
  vault_kv_path    = "secret"
  server_address   = "192.0.2.10"
}

run "every_host_name_points_at_the_server" {
  command = apply

  assert {
    condition = output.dns_records == {
      "webmail.example.org" = [{ type = "A", name = "webmail.example.org", content = "192.0.2.10", priority = null, comment = "Webmail" }]
      "webmail.example.net" = [{ type = "A", name = "webmail.example.net", content = "192.0.2.10", priority = null, comment = "Webmail" }]
    }
    error_message = "The webmail host names do not point at the server."
  }
}

run "it_signs_in_to_the_mail_server_of_the_project" {
  command = apply

  assert {
    condition     = output.jmap_url == "https://mail.example.org"
    error_message = "The webmail does not take the JMAP server from apps.mail.hostname."
  }
}
