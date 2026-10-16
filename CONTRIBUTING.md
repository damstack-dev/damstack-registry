# Contributing

A change to a stack, or a new one, comes as a pull request. It goes in once
the checks pass and the owner approves it; nothing is pushed to main directly,
and only the owner tags releases.

Before opening one:

1. `git config core.hooksPath hooks`, so that `scripts/check-private` runs on
   every commit.
2. `damstack stack lint <dir>` and `damstack stack check <dir>` pass for the
   stack you changed.
3. Nothing of a person or a project is in it: see the README. A value that
   must stay, such as a public resolver, goes in `.privacy-allow` with why.

A new stack goes in `platforms/<name>` or `apps/<name>`, where `<name>` is the
`name` in its `damstack.yaml`.
