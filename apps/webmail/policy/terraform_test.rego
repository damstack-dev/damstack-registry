package terraform

import rego.v1

change(addr, actions) := {"resource_changes": [{
	"address": addr,
	"type": "nomad_dynamic_host_volume",
	"change": {"actions": actions},
}]}

test_destroying_the_data_is_denied if {
	count(deny) == 1 with input as change("module.webmail.nomad_dynamic_host_volume.data", ["delete"])
		with data.apps as {"webmail": {}}
}

test_replacing_a_volume_is_denied if {
	count(deny) == 1 with input as change("module.webmail.nomad_dynamic_host_volume.data", ["delete", "create"])
		with data.apps as {"webmail": {}}
}

test_changing_a_volume_is_allowed if {
	count(deny) == 0 with input as change("module.webmail.nomad_dynamic_host_volume.data", ["update"])
		with data.apps as {"webmail": {}}
}

test_an_address_in_allow_destroy_may_go if {
	count(deny) == 0 with input as change("module.webmail.nomad_dynamic_host_volume.data", ["delete"])
		with data.apps as {"webmail": {"allow_destroy": ["module.webmail.nomad_dynamic_host_volume.data"]}}
}
