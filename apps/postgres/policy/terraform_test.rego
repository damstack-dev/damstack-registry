package terraform

import rego.v1

change(typ, actions) := {"resource_changes": [{
	"address": "module.postgres.nomad_dynamic_host_volume.data",
	"type": typ,
	"change": {"actions": actions},
}]}

test_destroying_the_data_is_denied if {
	count(deny) == 1 with input as change("nomad_dynamic_host_volume", ["delete"])
		with data.apps as {"postgres": {}}
}

test_replacing_the_data_is_denied if {
	count(deny) == 1 with input as change("nomad_dynamic_host_volume", ["delete", "create"])
		with data.apps as {"postgres": {}}
}

test_changing_the_data_is_allowed if {
	count(deny) == 0 with input as change("nomad_dynamic_host_volume", ["update"])
		with data.apps as {"postgres": {}}
}

test_an_address_in_allow_destroy_may_go if {
	count(deny) == 0 with input as change("nomad_dynamic_host_volume", ["delete"])
		with data.apps as {"postgres": {"allow_destroy": ["module.postgres.nomad_dynamic_host_volume.data"]}}
}
