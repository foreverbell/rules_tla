# rules_tla

This is a fork of https://github.com/johnynek/rules_tla. The original repository is broken.

Bazel rules for TLA+.

Notice the bazel extension is rather rudimentary and may be fragile.

Try it with `bazel test examples/...`.

# Example

```bazel
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
