# damstack-mimir

A [damstack](https://github.com/eugene-panin/damstack) app: a shared Mimir log
store, on a Nomad platform such as
[hashi](https://github.com/eugene-panin/damstack-hashi). The server is the
[terraform-nomad-mimir](https://github.com/eugene-panin/terraform-nomad-mimir)
module.

```sh
damstack app add mimir -p <project>
damstack deploy <project>
```

Edit `apps.mimir` with `damstack edit`: `retention_period` (default `0s`).

After the deploy, `damstack mimir output` prints `host`, `http_port` and
`service_name`. The platform's Alloy remote_writes metrics to `host:http_port`; Grafana
queries it.

## Development

```sh
damstack stack lint .
conftest verify -p policy
```
