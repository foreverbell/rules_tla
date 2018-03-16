def _tla_module_impl(ctx):
  transitive_files = depset(ctx.files.src)
  for dep in ctx.attr.deps:
    transitive_files += dep.default_runfiles.files

  return struct(
    files = depset(ctx.files.src),
    src = ctx.files.src[0],
    runfiles = ctx.runfiles(
      transitive_files = transitive_files,
      collect_default = True,
    )
  )

tla_module = rule(
  implementation = _tla_module_impl,
  attrs = {
    "src" : attr.label(allow_files = True),
    "deps" : attr.label_list(allow_files = False),
  }
)

def _tlc_runner(ctx, content):
  transitive_files = depset(ctx.attr.module.default_runfiles.files)
  for dep in ctx.attr.deps:
    transitive_files += dep.default_runfiles.files

  ctx.file_action(
    output = ctx.outputs.executable,
    content = content
  )

  return struct(
    files = depset([ctx.outputs.executable]),
    runfiles = ctx.runfiles(
      files = transitive_files.to_list() + [ctx.file.cfg] + ctx.files._tlc + ctx.files._tla,
      collect_data = True
    )
  )

def _tlc_impl(ctx):
  mod_src = ctx.attr.module.src

  script = """#!/bin/bash
python {runner} {tla2tools} {input} {config} {workers} {deadlock}
"""

  content = script.format(
    runner = ctx.executable._tlc.short_path,
    tla2tools = ctx.files._tla[0].path,
    input = mod_src.short_path,
    config = ctx.file.cfg.short_path,
    workers = ctx.attr.workers,
    deadlock = ctx.attr.workers,
  )
  print(ctx.files._tla[0].root)
  print(content)

  return _tlc_runner(ctx, content)

tlc_test = rule(
  implementation = _tlc_impl,
  attrs = {
    "module" : attr.label(allow_files = False),
    "cfg" : attr.label(single_file = True, allow_files = True),
    "deps" : attr.label_list(allow_files = False),
    "workers" : attr.int(default = 1),
    "deadlock" : attr.bool(default = False),
    "_tlc" : attr.label(default = Label("//tla:tlc_runner"), executable = True, cfg = "host"),
    "_tla" : attr.label(default = Label("@tla2tools//jar"), allow_files=True),
  },
  executable = True,
  test = True
)

def tla_repositories():
  native.http_jar(
    name = "tla2tools",
    url = "https://tla.msr-inria.inria.fr/tlatoolbox/dist/tla2tools.jar",
  )
