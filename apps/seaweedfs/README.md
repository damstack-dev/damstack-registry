# damstack-seaweedfs

A [damstack](https://github.com/eugene-panin/damstack) app: a shared SeaweedFS
object lake with an S3 API other apps read and write, on a Nomad platform such as
[hashi](https://github.com/eugene-panin/damstack-hashi). The server is the
[terraform-nomad-seaweedfs](https://github.com/eugene-panin/terraform-nomad-seaweedfs)
module.

## Add it to a project

```sh
damstack app add seaweedfs -p <project>
damstack deploy <project>
```

Edit `apps.seaweedfs` with `damstack edit`:

- `bucket` — the one bucket all identities are granted on.
- `identities` — `[{name, actions}]`; each gets an access key equal to its name
  and a generated secret key in Vault, with those actions on the bucket.

The default is one writer. For an app, set its own identities (for Sauron: a
`fetcher` with `Admin/Read/Write/List/Tagging` and readers `ingest`,
`incidents`, `transcriber`, `ui`, `tools` with `Read/List`).

After the deploy, `damstack seaweedfs output` prints `host`, `s3_port`, `bucket`
and `keys_secret` (the Vault name of the secret keys). A client connects to
`host:s3_port`, access key = its identity name, secret key from that Vault
secret.

## Development

```sh
damstack stack lint .
conftest verify -p policy
```
