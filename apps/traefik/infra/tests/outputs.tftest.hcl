mock_provider "nomad" {}

variables {
  state_passphrase = "a passphrase for the test only"
}

run "it_is_the_public_entry_with_http_01" {
  command = apply

  assert {
    condition     = output.entrypoints == tolist(["public-http", "public-https"])
    error_message = "The entrypoints are not public-http and public-https."
  }

  assert {
    condition     = output.certresolver == "http"
    error_message = "The certificate resolver is not http, HTTP-01."
  }

  assert {
    condition     = output.servers_transport == "proxy-protocol@file"
    error_message = "The TCP servers transport is not proxy-protocol@file."
  }

  assert {
    condition     = output.acme_volume == "traefik-public-certificates"
    error_message = "The certificates are not on the volume traefik-public-certificates."
  }

  assert {
    condition     = output.service_name == "traefik-public"
    error_message = "The job is not traefik-public, apart from the platform's internal traefik."
  }
}
