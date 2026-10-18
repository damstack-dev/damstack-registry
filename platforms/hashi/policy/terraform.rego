package terraform

import data.rules

deny contains msg if {
	some rc in input.resource_changes
	rc.type in rules.protected_types
	"delete" in rc.change.actions
	not rc.address in rules.allow_destroy
	msg := sprintf("%s: would be destroyed; add the address to allow_destroy in policy/data/rules.yaml to allow it", [rc.address])
}

deny contains msg if {
	some rc in input.resource_changes
	rc.type == "vault_kv_secret_v2"
	rc.change.after.data_json != null
	msg := sprintf("%s: data_json keeps the secret in the state; use data_json_wo", [rc.address])
}

deny contains msg if {
	some rc in input.resource_changes
	rc.type == "vault_generic_secret"
	rc.change.after != null
	msg := sprintf("%s: vault_generic_secret keeps the secret in the state; use vault_kv_secret_v2 with data_json_wo", [rc.address])
}
