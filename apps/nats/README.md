# damstack-nats

A [damstack](https://github.com/eugene-panin/damstack) app: a shared NATS
(JetStream) bus other apps publish and subscribe on, on a Nomad platform such as
[hashi](https://github.com/eugene-panin/damstack-hashi). The server is the
[terraform-nomad-nats](https://github.com/eugene-panin/terraform-nomad-nats)
module.

## Add it to a project

```sh
damstack app add nats -p <project>
damstack deploy <project>
```

Edit `apps.nats` with `damstack edit`:

- `users` — the NATS user names; a password is generated for each into Vault.
- `config` — the `nats.conf`, which names those users and refers to each password
  as `$NATS_<USER>_PASSWORD`.

The default is a single `app` user with unrestricted permissions — a working
generic bus. To lock it down for an app, replace both with that app's own config
and users (for Sauron: `python -m sauron.services.natsconf` and its six
services).

After the deploy, `damstack nats output` prints `host`, `client_port` and
`credentials_secret` (the Vault name of the passwords). A client connects to
`host:client_port` and reads its own password from that Vault secret.

## Development

```sh
damstack stack lint .
conftest verify -p policy
```
