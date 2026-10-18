# cloudflare

A [damstack](https://github.com/eugene-panin/damstack) domain: your domains on
Cloudflare, with the DNS records the apps of the project need published there
by damstack. It provides `public-dns@1`.

```bash
damstack app add cloudflare -p <project>
damstack deploy <project>
```

damstack asks for the zones on your Cloudflare account it may add records to,
and a token with Zone DNS Edit and Zone Read on them (the secret
`cloudflare_api_token`, made at https://dash.cloudflare.com/profile/api-tokens).
The zones go under `apps.cloudflare.zones` of `stack.yaml`.

Each app that needs public names, such as mail or odoo, leaves its records in
`dns/<app>.json` of the project. After the steps of every app, the step
`records` publishes them with
[terraform-nomad-hashistack](https://github.com/eugene-panin/terraform-nomad-hashistack)'s
`modules/dns-cloudflare`: the records of a domain go into the zone it is or is
under, the longest such. Records of names under no zone are not published:

- `damstack cloudflare output manual_records` lists them, to add by hand;
- `damstack cloudflare plan` shows what a deploy would change.

## From hashi before v1.0.0

The `dns` step of hashi published these records before; its state is
`state/dns.tfstate` of the project, encrypted with the same passphrase. Copy
it to `state/cloudflare-records.tfstate` before the first deploy of this
domain, and the records are taken over as they are (a `moved` block maps
hashi's `module.cloudflare[0]` here) instead of being made again beside
the old ones. Remove `dns/hashi.json` first: it holds the records of the old
admin pages under `infra_domain`, which hashi v1.0.0 no longer serves, and
the plan then deletes them.

## Tested

`damstack stack check` validates the OpenTofu, and `tofu test` with a mocked
Cloudflare provider checks, on [`records/tests/project`](records/tests/project),
that the records of a domain in the zones are published and those of another
are listed to add by hand.

## License

MIT, see [LICENSE](LICENSE).
