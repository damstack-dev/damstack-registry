# traefik

A [damstack](https://github.com/eugene-panin/damstack) app: the public entry of
a project, Traefik on ports 80 and 443, on a platform that provides Nomad and
Consul, such as [hashi](../../platforms/hashi). It is the role `public` of
[terraform-nomad-hashistack](https://github.com/eugene-panin/terraform-nomad-hashistack)'s
`modules/traefik`.

```bash
damstack app add traefik -p <project>
damstack deploy <project>
```

damstack asks for the e-mail of the Let's Encrypt account and puts it under
`apps.traefik` of `stack.yaml`, with `public_ports: [80, 443]`, which the
platform opens on the server. The deploy runs the Nomad job `traefik-public`
beside the platform's internal Traefik.

It provides `ingress-public@1` and `tls-certificates@1`: a public app tags its
Consul service with a router on the entrypoint `public-https` and the
certificate resolver `http`, and Traefik gets its certificate from Let's
Encrypt through HTTP-01 once the app's DNS record points at the server
(`public-http` redirects to HTTPS and answers the challenges). For TLS
passthrough, a TCP router names the servers transport `proxy-protocol@file`.
The ACME account and the certificates live on the host volume
`traefik-public-certificates`, which the backups copy.

- `damstack traefik plan` shows what a deploy would change.
- `damstack traefik output` prints the entrypoints, the resolver and the volume.

The policies refuse a plan that would destroy the certificates' volume; list
its address under `apps.traefik.allow_destroy` to let it go.

The platform's firewall step opens `public_ports` of the apps, but damstack
skips it while the platform's own inputs are unchanged, which an app's block
is not part of: on a platform already set up, `damstack deploy <project> --all`
opens 80 and 443 the first time.

## Tested

`damstack stack check` sets up a hashi project from
[`test/platform.yaml`](test/platform.yaml) with the app from
[`test/answers.yaml`](test/answers.yaml), and checks that OpenTofu validates,
that the policies pass their tests, and with `tofu test` and a mocked Nomad
provider, that the job is `traefik-public` with the entrypoints `public-http`
and `public-https`, the resolver `http` and its volume.

## License

MIT, see [LICENSE](LICENSE).
