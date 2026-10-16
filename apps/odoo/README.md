# damstack-odoo

An [damstack](https://github.com/eugene-panin/damstack) app: Odoo with its own
PostgreSQL, on a Nomad platform such as
[hashi](https://github.com/eugene-panin/damstack-hashi). The job is the
[terraform-nomad-odoo](https://github.com/eugene-panin/terraform-nomad-odoo)
module; this stack wires it to the platform and keeps the data safe.

## Add it to a project

```sh
damstack app add odoo -p <project>
damstack deploy <project>
```

It asks for:

- **hostname** — the name Odoo is served on, e.g. `odoo.example.com`.

The rest live in `apps.odoo` of the project's `stack.yaml` with defaults, edit
them with `damstack edit`: `image` (base Odoo, default `odoo:19.0`), `postgres`
(`mode: bundled` with its `image`, or `mode: external` with `host`/`port` for a
shared PostgreSQL), `db_name`, `workers`, `demo`.

## Addons

The image is base Odoo — no addons baked in. Addons are delivered **separately**
into the `odoo-addons` host volume, mounted at `/mnt/extra-addons`. Install Odoo
first, then add a module later: put its directory in that volume, restart Odoo,
and install the module in the Odoo UI. No image rebuild.

After the deploy:

- Odoo is at `https://<hostname>` once its certificate comes and DNS has spread.
- The master password of the database manager: `damstack odoo output admin_password`.

## What it sets up

- A Nomad job with Odoo, its PostgreSQL, and a wait-for-database task, each in
  the right order (see the module's README).
- Two dynamic host volumes, for the filestore and the database, that the
  platform's backup copies by name.
- The secrets (database and master passwords) in Vault.
- A Traefik route for the host name on the public HTTPS entrypoint, and a second
  one for `/websocket`.
- The `A` record of the host name, published by the platform.

Odoo opens no public port of its own; it faces the internet only through
Traefik. So `apps.odoo.public_ports` is empty and the firewall gains no rule.

## Bringing an existing Odoo over

The module provisions empty volumes; a fresh database is initialised by Odoo on
first run. To move an existing Odoo onto the platform, after the first deploy:

1. `damstack odoo output admin_password` and keep it.
2. Copy the old `pg_dump` and filestore onto the server.
3. `damstack ssh <project>` and, with the job stopped, restore the dump into the
   `odoo-pgdata` volume and the filestore into `odoo-filestore`, then start the
   job again.

Pin `odoo_image` to the **same Odoo version** the dump came from, or the first
start will want to migrate the schema.

## Development

```sh
damstack stack lint .
damstack stack check .          # renders test/answers.yaml, runs policy and tofu tests
conftest verify -p policy
```
