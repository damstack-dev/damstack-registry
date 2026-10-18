output "manual_records" {
  description = "DNS records to create by hand, keyed by domain: those of names under none of the zones."
  value = {
    for d in distinct(flatten([for set in local.sets : keys(set)])) :
    d => flatten([for set in local.sets : lookup(set, d, [])])
    if !contains(keys(module.cloudflare.zone_ids), d)
  }
}

output "published" {
  description = "The records on Cloudflare, by \"<type> <name>\"."
  value       = sort(keys(module.cloudflare.record_ids))
}
