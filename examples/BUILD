load("//tla:tla.bzl", "tla_module", "tlc_test")

tla_module(
  name = "hourclock_good",
  src = "good/hourclock.tla",
)

tla_module(
  name = "hourclock_bad",
  src = "bad/hourclock.tla",
)

tlc_test(
  name = "hourclock_good_tlc",
  cfg = "good/hourclock.cfg",
  module = ":hourclock_good",
)

tlc_test(
  name = "hourclock_bad_tlc",
  cfg = "bad/hourclock.cfg",
  module = ":hourclock_bad",
)