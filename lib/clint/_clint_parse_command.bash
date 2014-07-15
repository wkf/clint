_clint_get_command_name() { echo "${1%%  *}"; }
_clint_get_command_description() { echo "${1##*  }"; }

_clint_parse_command() {
  if [[ -n ${CLINT_ARGV[0]-} ]]; then
    CLINT_COMMAND="${CLINT_ARGV[0]}"
  else
    _clint_error "missing command"
  fi

  if [[ -n ${CLINT_COMMAND_DESCRIPTORS["$CLINT_COMMAND"]+_} ]]; then
    [[ $CLINT_COMMAND =~ help ]] && { _clint_print_help; exit 0; }
    [[ $CLINT_COMMAND =~ version ]] && { _clint_print_version; exit 0; }

    CLINT_ARGV=("${CLINT_ARGV[@]:1}")
  else
    _clint_error "unknown command: \"$CLINT_COMMAND\""
  fi
}
