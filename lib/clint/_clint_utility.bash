
_clint_print_version() {
  echo "$CLINT_VERSION"
}

_clint_print_help() {
  echo
  echo "  $CLINT_HELP"
  echo
}

_clint_error() {
  echo
  echo "$(tput bold)$(tput setaf 1)  error: $1$(tput sgr0)"
  _clint_print_help
  exit 1
}
