# damstack-postgres

A [damstack](https://github.com/eugene-panin/damstack) app: a shared PostgreSQL
other apps use when they set `postgres.mode = external`, on a Nomad platform such
as [hashi](https://github.com/eugene-panin/damstack-hashi). The server is the
[terraform-nomad-postgres](https://github.com/eugene-panin/terraform-nomad-postgres)
module.

It is deliberately dumb: one PostgreSQL, a superuser credential in Vault, a
Consul service. **It knows nothing about the databases on it.** Each consumer app
makes its own role and database — a new database is never a change here.

## Add it to a project

```sh
damstack app add postgres -p <project>
damstack deploy <project>
```

It asks nothing; edit `apps.postgres` of the project's `stack.yaml` with
`damstack edit` to change `image`, `admin_user` or `port`.

After the deploy:

- PostgreSQL answers inside the platform as the Consul service `postgres`, on the
  server's internal address.
- The superuser password: `damstack postgres output admin_password`.
- The connection a consumer needs: `damstack postgres output` prints `host`,
  `port` and `admin_secret` (the Vault name of the superuser credential).

## Wiring a consumer

Deploy this first, then point a consumer at it. For `odoo`:

```yaml
# apps.odoo in the project's stack.yaml
postgres:
  mode: external
  host: 10.77.0.1          # damstack postgres output host
  port: 5432
  admin_secret: default/postgres/admin
```

Odoo then creates its own role and database on first start, using the superuser
credential from Vault. Deploy order matters: PostgreSQL before its consumers.

## Development

```sh
damstack stack lint .
damstack stack check .
conftest verify -p policy
```
