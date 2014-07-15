
for f in "$(dirname "${BASH_SOURCE[0]}")"/clint/_*.bash; do
  source "$f"
done

clint_start() {
  unset CLINT_FLAGS
  unset CLINT_COMMAND
  unset CLINT_COMMAND_DESCRIPTORS
  unset CLINT_OPTION_VALUES
  unset CLINT_OPTION_DESCRIPTORS
  unset CLINT_PARAMETER_VALUES
  unset CLINT_PARAMETER_DESCRIPTORS

  declare -g CLINT_ARGV
  declare -g CLINT_HELP
  declare -g CLINT_VERSION
  declare -g CLINT_COMMAND
  declare -g -A CLINT_FLAGS
  declare -g -A CLINT_COMMAND_DESCRIPTORS
  declare -g -A CLINT_OPTION_VALUES
  declare -g -A CLINT_OPTION_DESCRIPTORS
  declare -g -A CLINT_PARAMETER_VALUES
  declare -g -a CLINT_PARAMETER_DESCRIPTORS

  if [[ -n $@ ]]; then
    CLINT_ARGV=("$@")
  fi

  read -r -d '' CLINT_HELP

  _clint_parse
}

clint_continue() { clint_start; }

clint_command() { echo "$CLINT_COMMAND"; }

clint_help() { _clint_print_help; }
clint_version() { _clint_print_version; }

clint_option() { echo "${CLINT_OPTION_VALUES["$1"]-}"; }
clint_parameter() { echo "${CLINT_PARAMETER_VALUES["$1"]-}"; }
