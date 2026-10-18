# manual

A [damstack](https://github.com/eugene-panin/damstack) domain: your domains at
any DNS provider. You add the records the apps of the project need by hand,
and damstack looks them up. It provides `public-dns@1`.

```bash
damstack app add manual -p <project>
damstack deploy <project>
```

Each app that needs public names, such as mail or odoo, leaves its records in
`dns/<app>.json` of the project. After the steps of every app, the step
`records` prints them by domain, then looks each one up with `dig` and says
which are not in DNS yet. It does not fail the deploy: a new record can take a
while to spread. `damstack manual records` does the same any time.

It is [`records.py`](records.py), run with the Python of damstack's toolbox.

## Tested

`damstack stack check` runs it on [`test/mail.json`](test/mail.json) without
looking anything up, and checks the records it prints.

## License

MIT, see [LICENSE](LICENSE).
