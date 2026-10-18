package terraform

import rego.v1

change(actions) := {"resource_changes": [{
	"address": "module.traefik.nomad_dynamic_host_volume.acme_storage[0]",
	"type": "nomad_dynamic_host_volume",
	"change": {"actions": actions},
}]}

test_destroying_the_certificates_is_denied if {
	count(deny) == 1 with input as change(["delete"]) with data.apps as {"traefik": {}}
}

test_replacing_the_certificates_is_denied if {
	count(deny) == 1 with input as change(["delete", "create"]) with data.apps as {"traefik": {}}
}

test_changing_the_certificates_is_allowed if {
	count(deny) == 0 with input as change(["update"]) with data.apps as {"traefik": {}}
}

test_an_address_in_allow_destroy_may_go if {
	count(deny) == 0 with input as change(["delete"])
		with data.apps as {"traefik": {"allow_destroy": ["module.traefik.nomad_dynamic_host_volume.acme_storage[0]"]}}
}
