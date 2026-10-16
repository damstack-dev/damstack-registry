# damstack-grafana

A [damstack](https://github.com/eugene-panin/damstack) app: Grafana for the
platform, on a Nomad platform such as
[hashi](https://github.com/eugene-panin/damstack-hashi). The server is the
[terraform-nomad-grafana](https://github.com/eugene-panin/terraform-nomad-grafana)
module.

```sh
damstack app add grafana -p <project>
damstack deploy <project>
```

It serves `grafana.<infra_domain>` on Traefik's internal entrypoint (WireGuard
only), with the `mimir` and `loki` apps wired as data sources. Edit
`apps.grafana` with `damstack edit` if those apps use non-default ports
(`mimir_port`, `loki_port`).

After the deploy:

- Grafana is at `https://grafana.<infra_domain>`, through WireGuard.
- The admin password: `damstack grafana output admin_password`.
- `damstack grafana output admin_secret` gives the Vault name a consumer app
  reads to push its own dashboards and alerts with the grafana provider.

Deploy `mimir` and `loki` before Grafana so its data sources resolve.

It uses `metrics@1` and `logs@1`: `damstack app add grafana` offers the
providers the platform has, and each one connected is a data source, at the
address, port and `path` the platform's Consul gives, the first metrics one the
default. Without providers of one, its data source is as before: Mimir or Loki at
`mimir_host`/`loki_host`, by default `mimir.service.consul:9009` and
`loki.service.consul:3100`.

## Development

```sh
damstack stack lint .
conftest verify -p policy
```
