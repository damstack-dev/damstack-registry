# damstack-hashi

A [damstack](https://github.com/eugene-panin/damstack) platform: Consul, Vault
and Nomad on one server, their admin pages over WireGuard, with nightly
backups, ready for apps such as [mail](../../apps/mail). It needs no domain: a
server with Ubuntu 24.04 you reach by SSH, with its root password or a key, and
the WireGuard app on the devices that open the admin pages.

```bash
damstack deploy hashi
```

damstack asks the questions in [`damstack.yaml`](damstack.yaml), writes the
project, then runs the steps: `bootstrap` creates the ops user and locks the
server down to your key, once; `provision` sets up WireGuard, Consul, Vault,
Nomad and the backups; `apply` plans the resources on the platform, checks the
plan against the policies, and applies it when you say yes.

The admin pages are `https://nomad.service.consul`, `https://vault.service.consul`
and `https://consul.service.consul`, with the tokens of `damstack token nomad`,
`vault` and `consul`. They are Consul names, served by an internal Traefik on the
private network with a certificate the project's CA signs: the devices' WireGuard
configurations take the server's Consul as their DNS, and `damstack trust` makes
the Mac trust the CA and send the `.consul` names through the tunnel
(`/etc/resolver/consul`).

`damstack app add mail` adds an app. The platform `provides` `nomad@1`, `vault-kv@1`,
`consul@1`, `ingress-internal@1` and `observability@1`, and gives every app `NOMAD_*`, `CONSUL_*` and
`VAULT_*` to reach them; an app opens its ports on the server with
`public_ports` in its block of `stack.yaml`. The public entry is an app of its
own, [traefik](../../apps/traefik), with its certificates from Let's Encrypt,
and a domain module, [cloudflare](../../domains/cloudflare) or
[manual](../../domains/manual), publishes the DNS records the apps need.

In a project, `damstack plan` shows what `apply` would change,
`damstack output` prints the OpenTofu outputs, and
`damstack provision --check --diff` shows what `provision` would change.

The project is data only: `stack.yaml`, the one file you edit, the encrypted
`vault.yml`, `ca.pem` and the encrypted OpenTofu state in `state/`. The code
is this stack, at the version the project was deployed with.

The WireGuard keys of the server and of every device in `network.clients` are
made by damstack on the laptop and kept in `vault.yml` as `vault_wireguard`:
the server gets the public keys and a preshared key per device, nothing
private. `damstack tunnel show <device>` puts a device's configuration into
the WireGuard app, or shows a QR code with `--qr`; `damstack tunnel add`,
`remove` and `rotate` change them, setting them on the server with the
`wireguard` command, over the public address.

Every night the server backs up the snapshots of Consul, Nomad and Vault and
a copy of every host volume, by its name; `damstack backup pull` copies them
to the laptop. When the server is lost, `damstack restore` sets up a new one
from the latest snapshot on the laptop: `provision` restores Consul and starts
Vault from its snapshot, under the unseal keys and tokens in `vault.yml`;
`apply` and the apps make their jobs and volumes anew; then `restore-data`, a
step only a restore runs, puts the volumes back, stopping the jobs that use
them meanwhile. Nomad is not restored from its snapshot: everything in it
comes from OpenTofu. Tested on a GCP server: a mail, a key in Consul and a
secret in Vault came back on a new disk, and through a reboot.

## From hashi before v1.0.0

v1.0.0 has no domain: the admin pages leave `*.<infra_domain>` for
`*.service.consul`, the public Traefik leaves the platform for the
[traefik](../../apps/traefik) app, and the `dns` step for a domain,
[cloudflare](../../domains/cloudflare) or [manual](../../domains/manual).
Take the platform, `apps/traefik` and the domain to the new releases in one
deploy, as Traefik leaves hashi in the same release it joins the apps:

1. Pin hashi `v1.0.0`, add `traefik` and a domain to the project, and add
   `acme_email` to `apps.traefik` (and to `apps.mail`, which took the
   platform's before).
2. For cloudflare, copy `state/dns.tfstate` to
   `state/cloudflare-records.tfstate`, so it takes the records over instead
   of making them again; then remove `dns/hashi.json`, the records of the old
   admin pages.
3. `damstack status --live`, then deploy. The `apply` of the platform, with
   [terraform-nomad-hashistack 1.0.0](https://github.com/eugene-panin/terraform-nomad-hashistack/blob/main/CHANGELOG.md):
   - changes the job `traefik` in place to the internal entrypoint only: 80
     and 443 close until `apps/traefik` runs `traefik-public`, later in the
     same deploy, which asks Let's Encrypt for the certificates again unless
     `http.json` was copied from the volume `traefik-certificates` to
     `traefik-public-certificates`;
   - makes the certificate of `*.service.consul`, signed by the project's CA;
   - destroys the DNS token of the old Traefik in Vault,
     `module.stack.module.traefik.vault_kv_secret_v2.acme`, which
     `policy/data/rules.yaml` allows;
   - forgets the volume `traefik-certificates` and, with single sign-on on,
     `module.sso`: they stay in Nomad and Vault, no longer managed;
   - forgets the certificate the stack signed itself with
     `certificates.mode: internal-ca` (`removed` blocks).
4. `damstack trust <project>` once more, for `/etc/resolver/consul`, and
   `damstack tunnel show <device>` for every device, whose configuration now
   has the server's Consul as its DNS.

`infra_domain`, `acme_email`, `dns`, `certificates` and `sso` of
`stack.yaml`, and the secrets `vault_cloudflare_api_token`,
`vault_cloudflare_traefik_token`, `vault_acme_dns_env` and
`vault_sso_google_client_secret`, are no longer read; remove them when you
like. `server.public_ports` may stay `[80, 443]` or become `[]`, now that
`apps.traefik.public_ports` has them.

## Layout

- `damstack.yaml`: the questions, the secrets, and the steps;
- `template/stack.yaml.tmpl`: the `stack.yaml` a new project starts from;
- `ansible/`: the playbooks and the inventory, whose variables come from
  `stack.yaml` and `vault.yml` of the project;
- `infra/`: the OpenTofu root module of the platform, with a lock file for Linux amd64 and arm64;
- `policy/`: the Conftest policies every plan passes before it is applied.

## Tested

`damstack stack check` sets up a project from [`test/answers.yaml`](test/answers.yaml)
and checks that the playbooks parse, OpenTofu validates against the project,
the policies pass their tests, and that `stack.yaml` says what the answers
said and every variable the roles read resolves from the project
([`test/resolve.yml`](test/resolve.yml)).

[`test/bootstrap.sh`](test/bootstrap.sh) runs the bootstrap playbook against
fresh Ubuntu 24.04 servers in containers: a new ops user, a second run that
changes nothing, a rename refused, an existing user left alone or taken over
with `adopt_user`, a system user refused, and the user the server came with
kept as the ops user.

## License

MIT, see [LICENSE](LICENSE).
