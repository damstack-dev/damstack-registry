# webmail

A damstack app: webmail for every domain of the [mail](../mail) app, by
[Bulwark](https://github.com/bulwarkmail/webmail), over JMAP. People sign in
with their full address and the password of the mailbox. The job is the
[terraform-nomad-bulwark](https://github.com/damstack-dev/terraform-nomad-bulwark)
module.

## Add it to a project

```sh
damstack app add webmail -p <project>
damstack deploy <project>
```

It asks for:

- **hostnames**: the names the webmail is served on, such as
  `webmail.example.com`; one per mail domain if you like, all served by the
  one webmail.

It signs in to `https://<apps.mail.hostname>`, the mail server of the project.
Set `apps.webmail.jmap_url` for another one.

The browser calls the mail server itself, so the mail server has to allow it:
set `apps.mail.permissive_cors: true` and deploy the mail app again.

## What it sets up

- A Nomad job with Bulwark, behind the public entry, `ingress-public@1`, such
  as the [traefik](../traefik) app, with a certificate for every host name.
- A session secret in Vault.
- A host volume, `webmail-data`, for the settings people save; the platform's
  backup copies it by name, and the policies refuse to destroy it.
- An `A` record for every host name, in `dns/webmail.json` of the project,
  published by the project's domain, `public-dns@1`.

The webmail opens no public port of its own.

## Development

```sh
damstack stack lint .
damstack stack check .
conftest verify -p policy
```
