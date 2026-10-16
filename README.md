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
