from sys import stderr, argv
from os import chdir
from os.path import dirname, basename, abspath
from subprocess import check_output

tla2tools_path = abspath(argv[1])
tla_dir = dirname(argv[2])
cfg_dir = dirname(argv[3])

if tla_dir != cfg_dir:
  stderr.write('tla source and tlc configuration not in same directory.')
  exit(1)

parameters = []

# Sets up TLA source file.
parameters.append(basename(argv[2]))

# Sets up TLC configuration file.
parameters.append('-config')
parameters.append(basename(argv[3]))

# Sets up workers.
parameters.append('-workers')
parameters.append(argv[4])

# Does not check for deadlock if set.
if argv[5] == 'False':
  parameters.append('-deadlock')

# TLA code assumes that all paths are in the current directory. So `chdir` into
# that.
if len(tla_dir) > 0:
  chdir(tla_dir)

# Invokes TLC model checker.
tlc_result = check_output(["java", "-cp", tla2tools_path, "tlc2.TLC"] + parameters)

# Finds clues whether TLC succeeds from TLC output.
ok = False
for l in tlc_result.splitlines():
  if l.startswith("Model checking completed. No error has been found."):
    ok = True
    break

if ok:
  exit(0)

stderr.write(tlc_result)
exit(1)
