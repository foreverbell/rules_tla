# rules_tla

This is a fork of https://github.com/johnynek/rules_tla. The original repository
is broken.

Bazel rules for TLA+.

Notice the bazel extension is rather rudimentary and may be fragile. Known to
work with the following TLC version:

```text
TLC2 Version 2.12 of 29 January 2018 (rev: 2cf4197)
```

To get started, execute `bazel test examples/...`.

# Setup

Add the following to your `WORKSPACE` file to add the external repositories.

```
git_repository(
  name = "rules_tla",
  remote = "https://github.com/foreverbell/rules_tla.git",
  # NOT VALID! Replace this with a Git commit SHA.
  commit = "{HEAD}",
)

load("@rules_tla//tla:tla.bzl", "tla_repositories")
tla_repositories()
```

# Example

```bazel
load(
  "@rules_tla//tla:tla.bzl",
  "tla_module", "tlc_test"
)

tla_module(
  name = "hourclock",
  src = "hourclock.tla",
)

tlc_test(
  name = "hourclock_tlc",
  cfg = "hourclock.cfg",
  module = ":hourclock",
  workers = 4,
  deadlock = True,
)
```
