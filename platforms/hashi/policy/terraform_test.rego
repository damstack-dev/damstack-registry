package terraform_test

import data.terraform

change(type, actions, after) := {"resource_changes": [{
	"address": sprintf("%s.x", [type]),
	"type": type,
	"change": {"actions": actions, "after": after},
}]}

test_protected_destroy_denied if {
	count(terraform.deny) == 1 with input as change("vault_mount", ["delete"], null)
}

test_protected_replace_denied if {
	count(terraform.deny) == 1 with input as change("nomad_dynamic_host_volume", ["delete", "create"], {})
}

test_allowed_destroy if {
	count(terraform.deny) == 0 with input as change("vault_mount", ["delete"], null)
		with data.rules.allow_destroy as ["vault_mount.x"]
}

test_unprotected_destroy_allowed if {
	count(terraform.deny) == 0 with input as change("nomad_job", ["delete"], null)
}

test_write_only_secret_allowed if {
	count(terraform.deny) == 0 with input as change("vault_kv_secret_v2", ["create"], {"data_json": null, "data_json_wo": null})
}

test_secret_in_state_denied if {
	count(terraform.deny) == 1 with input as change("vault_kv_secret_v2", ["create"], {"data_json": "{\"k\":\"v\"}"})
}

test_generic_secret_denied if {
	count(terraform.deny) == 1 with input as change("vault_generic_secret", ["create"], {"data_json": "{}"})
}

test_the_dns_token_of_the_old_traefik_may_go if {
	count(terraform.deny) == 0 with input as {"resource_changes": [{
		"address": "module.stack.module.traefik.vault_kv_secret_v2.acme",
		"type": "vault_kv_secret_v2",
		"change": {"actions": ["delete"], "after": null},
	}]}
}
