mock_provider "cloudflare" {}

variables {
  project          = "./tests/project"
  state_passphrase = "a passphrase for the test only"
}

run "records_in_the_zones_go_to_cloudflare_the_others_are_manual" {
  command = apply

  assert {
    condition     = output.published == tolist(["A mail.example.org", "MX example.org"])
    error_message = "The records of example.org and under it are not the ones published."
  }

  assert {
    condition     = jsonencode(keys(output.manual_records)) == jsonencode(["example.net"])
    error_message = "Only example.net, in no zone, is to be added by hand."
  }

  assert {
    condition     = output.manual_records["example.net"][0].type == "MX"
    error_message = "The manual record of example.net is not its MX."
  }
}
