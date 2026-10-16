package terraform

import rego.v1

change(actions) := {"resource_changes": [{
	"address": "module.seaweedfs.nomad_dynamic_host_volume.data",
	"type": "nomad_dynamic_host_volume",
	"change": {"actions": actions},
}]}

test_destroying_the_lake_is_denied if {
	count(deny) == 1 with input as change(["delete"]) with data.apps as {"seaweedfs": {}}
}

test_replacing_the_lake_is_denied if {
	count(deny) == 1 with input as change(["delete", "create"]) with data.apps as {"seaweedfs": {}}
}

test_changing_the_lake_is_allowed if {
	count(deny) == 0 with input as change(["update"]) with data.apps as {"seaweedfs": {}}
}

test_an_address_in_allow_destroy_may_go if {
	count(deny) == 0 with input as change(["delete"])
		with data.apps as {"seaweedfs": {"allow_destroy": ["module.seaweedfs.nomad_dynamic_host_volume.data"]}}
}
