package terraform

import rego.v1

change(addr, actions) := {"resource_changes": [{
	"address": addr,
	"type": "nomad_dynamic_host_volume",
	"change": {"actions": actions},
}]}

test_destroying_the_filestore_is_denied if {
	count(deny) == 1 with input as change("module.odoo.nomad_dynamic_host_volume.filestore", ["delete"])
		with data.apps as {"odoo": {}}
}

test_destroying_the_database_is_denied if {
	count(deny) == 1 with input as change("module.odoo.nomad_dynamic_host_volume.pgdata", ["delete"])
		with data.apps as {"odoo": {}}
}

test_replacing_a_volume_is_denied if {
	count(deny) == 1 with input as change("module.odoo.nomad_dynamic_host_volume.pgdata", ["delete", "create"])
		with data.apps as {"odoo": {}}
}

test_changing_a_volume_is_allowed if {
	count(deny) == 0 with input as change("module.odoo.nomad_dynamic_host_volume.filestore", ["update"])
		with data.apps as {"odoo": {}}
}

test_an_address_in_allow_destroy_may_go if {
	count(deny) == 0 with input as change("module.odoo.nomad_dynamic_host_volume.pgdata", ["delete"])
		with data.apps as {"odoo": {"allow_destroy": ["module.odoo.nomad_dynamic_host_volume.pgdata"]}}
}
