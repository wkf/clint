_clint_get_option_aliases() {
  echo "$1" | awk -F'  +' '{gsub(", ","\n",$1); print $1}' | awk -F' |=' '{print $1}'
}

_clint_get_option_description() {
  echo "${1##*  }"
}

_clint_get_option_default() {
  echo "$1" | sed -n 's|^.*\[default: \(.*\)\]$|\1|p'
}

_clint_get_option_type() {
  echo "$1" | egrep -q -- '-. [A-Z]+|--.+=[A-Z]+'; [[ $? == 0 ]] && echo STRING || echo BOOLEAN
}

_clint_parse_options() {
  local option=
  local value=
  local descriptor=
  local default=
  local type=

  set -- "${CLINT_ARGV[@]-}"

  while [[ $# > 0 ]]; do
    case "$1" in
      (--) shift; break ;;
      (-*)
        option="${1%=*}"

        if [[ -n ${CLINT_OPTION_DESCRIPTORS["$option"]+_} ]]; then
          descriptor="${CLINT_OPTION_DESCRIPTORS["$option"]}"
        else
          _clint_error "unknown option - \"$option\""
        fi

        type="$(_clint_get_option_type "$descriptor")"
        ;;&
      (-) value=y ;;
      (-?)
        case "$type" in
          (STRING)
            [[ -n ${2+_} ]] && value="$2" || _clint_error "missing argument - \"$option\""
            shift
            ;;
          (BOOLEAN) value=y ;;
        esac
        ;;
      (--?*=?*)
        value="${1#--*=}"
        [[ $type == STRING ]] || _clint_error "extra argument - \"$option\""
        ;;
      (--?*)
        value=y
        [[ $type == BOOLEAN ]] || _clint_error "missing argument - \"$option\""
        ;;
      (*) break ;;
    esac

    if [[ -n $descriptor ]] && [[ -n $value ]]; then
      while read -r a; do
        [[ $a =~ help ]] && { _clint_print_help; exit 0; }
        [[ $a =~ version ]] && { _clint_print_version; exit 0; }

        if [[ -n ${CLINT_OPTION_VALUES["$a"]+_} ]]; then
          _clint_error "duplicate option - \"$option\""
        else
          CLINT_OPTION_VALUES["$a"]="$value"
        fi
      done <<<"$(_clint_get_option_aliases "$descriptor")"
    fi

    shift
  done

  for o in "${!CLINT_OPTION_DESCRIPTORS[@]}"; do
    default="$(_clint_get_option_default "${CLINT_OPTION_DESCRIPTORS["$o"]}")"

    if [[ -z ${CLINT_OPTION_VALUES["$o"]+_} && -n $default ]]; then
      CLINT_OPTION_VALUES["$o"]="$default"
    fi
  done

  CLINT_ARGV=("$@")
}
