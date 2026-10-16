# damstack registry

The platforms and apps [damstack](https://github.com/eugene-panin/damstack)
deploys. Each stack is a directory with its `damstack.yaml`, and is released
by a tag of its own.

```
platforms/<name>/   a platform, such as hashi: Nomad, Consul and Vault on one server
apps/<name>/        an app that runs on a platform, such as mail
```

A release of a stack is a tag `<name>/vX.Y.Z` on main, such as `hashi/v0.23.0`
or `mail/v0.4.1`; damstack takes the latest one of the stack a project uses.

`index.yaml` lists the stacks for damstack. `scripts/index` writes it from
their `damstack.yaml`, and CI fails when it is not up to date: run it after
adding a stack or changing its description or capabilities.

## Capabilities

What a stack gives or needs is a capability, `name@major`; a stack that breaks
what one promises provides the next major. The ones in use:

| Capability | Promises | Provided by |
|---|---|---|
| `nomad@1` | a Nomad cluster the apps run their jobs on, `NOMAD_*` in their steps | hashi |
| `vault-kv@1` | a Vault KV engine for the apps' secrets, `VAULT_*` in their steps | hashi |
| `consul@1` | Consul and its DNS, `CONSUL_*` in the apps' steps | hashi |
| `ingress-traefik@1` | Traefik, routing by the tags of Nomad services | hashi |
| `observability@1` | the platform's Alloy, collecting metrics and logs | hashi |
| `logs@1` | a Loki push and query HTTP API | loki |
| `metrics@1` | a Prometheus query API, under the service meta `path` | mimir |
| `postgres@16` | a PostgreSQL 16 server, its superuser credential in Vault | postgres |
| `nats@2` | a NATS 2 server with JetStream | nats |
| `s3@1` | an S3 API | seaweedfs |

A new one is added here in the same pull request as the first stack that
provides it.

[The manifest reference](https://github.com/eugene-panin/damstack/blob/main/docs/manifest.md)
says what every field of `damstack.yaml` does.

## Nothing of a person or a project

The registry is public. A stack holds what every project of it shares, never
what one project or person has: no real addresses, domains, e-mail addresses,
keys, tokens, `vault.yml`, OpenTofu state or `known_hosts`. Examples use
`example.org`, `.test` names and `192.0.2.0/24`.

`scripts/check-private` looks for those in every pull request, with gitleaks
over every commit. Run it before each commit too:

```bash
git config core.hooksPath hooks
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Changes come by pull request and go
in once the owner approves them.

## License

MIT
