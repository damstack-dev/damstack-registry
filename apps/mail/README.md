# damstack-mail

A [damstack](https://github.com/eugene-panin/damstack) app: mail for your
domains, by [Stalwart](https://stalw.art), on a platform that provides Nomad
and Vault, such as [hashi](../../platforms/hashi), with a public entry
(`ingress-public@1`, the [traefik](../traefik) app) and a domain that publishes
its records (`public-dns@1`, [cloudflare](../../domains/cloudflare) or
[manual](../../domains/manual)).

```bash
cd ~/damstack/my-cloud
damstack app add mail
```

damstack asks for the name of the mail server, the domains and mailboxes, and
the e-mail of the Let's Encrypt account of the server's certificate, and puts
them under `apps.mail` of `stack.yaml`, where you change them later.
`damstack deploy` then runs Stalwart as a Nomad job with its store on a host
volume, opens 25, 465, 587 and 993 on the server, and leaves in
`dns/mail.json` of the project the records every domain needs, which the
project's domain publishes: MX, SPF, DKIM, DMARC, MTA-STS, TLS-RPT, the
names mail clients look up, and the name of the mail server.

- `damstack mail output passwords` prints the password of every mailbox.
- `damstack mail plan` shows what a deploy would change.

The policies refuse a plan that would destroy the mail store; list its address
under `apps.mail.allow_destroy` to let it go.

## From mail v0.5

v0.6.0 goes with hashi v1.0.0, which has no `acme_email` of its own: add
`acme_email` to `apps.mail` of `stack.yaml` (it took the platform's before)
before the first deploy, and add a domain, `damstack app add cloudflare` or
`manual`, for its records.

## Tested

`damstack stack check` sets up a hashi project from
[`test/platform.yaml`](test/platform.yaml) with the app from
[`test/answers.yaml`](test/answers.yaml), and checks that OpenTofu validates,
that the policies pass their tests, and with `tofu test` and mocked providers,
that the mail server's name points at the server and every domain gets an MX
to it, and that the mailboxes are those of `stack.yaml`.

## License

MIT, see [LICENSE](LICENSE).
