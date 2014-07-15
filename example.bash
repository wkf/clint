#!/usr/bin/env bash

set -o nounset
set -o errtrace
set -o pipefail

source lib/clint.bash

example() {
  clint_start "$@" <<EOF

  usage: example.bash [options] <command> [<arguments>...]

  commands:
    print              print the message
    help               print help
    version            print version

  options:
    -h, --help         display this message
    -v, --version      display version information

  version: 0.0.1

EOF

  example_"$(clint_command)"
}

example_print() {
  clint_continue <<EOF

  usage: example.bash print [options] <message>

  options:
    -t N, --times=N  print this many times [default: 2]
    -h, --help
    -v, --version

EOF

  local times="$(clint_option --times)"
  local message="$(clint_parameter message)"

  for i in $(seq 1 $times); do
    echo "$message"
  done
}

example "$@"
