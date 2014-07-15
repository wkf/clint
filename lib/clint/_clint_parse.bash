_clint_parse() {
  local state=INITIAL

  while read -r line; do
    case "$line" in
      ("") state=INITIAL; continue ;;
      (commands:) state=PARSE_COMMANDS; continue ;;
      (options:) state=PARSE_OPTIONS; continue ;;
      (usage:*) state=PARSE_USAGE ;;
      (version:*) state=PARSE_VERSION ;;
    esac

    case "$state" in
      (PARSE_COMMANDS)
        CLINT_COMMAND_DESCRIPTORS["$(_clint_get_command_name "$line")"]="$line"
        ;;
      (PARSE_OPTIONS)
        while read -r a; do
          CLINT_OPTION_DESCRIPTORS["$a"]="$line"
        done <<<"$(_clint_get_option_aliases "$line")"
        ;;
      (PARSE_USAGE)
        while read -r b; do
          CLINT_PARAMETER_DESCRIPTORS+=("$b")
        done <<<"$(_clint_parse_usage "$line")"
        ;;
      (PARSE_VERSION)
        CLINT_VERSION="${line#*: }"
        ;;
    esac
  done <<<"$CLINT_HELP"

  for p in "${CLINT_PARAMETER_DESCRIPTORS[@]}"; do
    case "$p" in
      (?options?) _clint_parse_options ;;
      (?command?) _clint_parse_command ;;
      (*) _clint_parse_parameter "$p" ;;
    esac
  done

  if [[ -n ${CLINT_ARGV[@]+_} && -z ${CLINT_FLAGS[parameter_soak]+_} ]]; then
    _clint_error "extra parameters - \"${CLINT_ARGV[@]}\""
  fi
}
