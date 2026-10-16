# damstack-loki

A [damstack](https://github.com/eugene-panin/damstack) app: a shared Loki log
store, on a Nomad platform such as
[hashi](https://github.com/eugene-panin/damstack-hashi). The server is the
[terraform-nomad-loki](https://github.com/eugene-panin/terraform-nomad-loki)
module.

```sh
damstack app add loki -p <project>
damstack deploy <project>
```

Edit `apps.loki` with `damstack edit`: `retention_period` (default `168h`).

After the deploy, `damstack loki output` prints `host`, `http_port` and
`service_name`. The platform's Alloy pushes logs to `host:http_port`; Grafana
queries it.

## Development

```sh
damstack stack lint .
conftest verify -p policy
```
