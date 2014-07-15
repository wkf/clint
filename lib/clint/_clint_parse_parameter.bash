_clint_is_parameter_dynamic() { [[ $1 == *\>* ]]; }
_clint_is_parameter_soak() { [[ $1 == *...* ]]; }
_clint_is_parameter_optional() { [[ $1 == *]* ]]; }

_clint_get_parameter_name() { echo "$1" | egrep -o '\w+'; }

_clint_parse_parameter() {
  local name="$(_clint_get_parameter_name "$1")"
  local value="${CLINT_ARGV[0]-}"
  local is_soak=
  local is_optional=
  local is_dynamic=

  _clint_is_parameter_soak "$1" && is_soak=y
  _clint_is_parameter_optional "$1" && is_optional=y
  _clint_is_parameter_dynamic "$1" && is_dynamic=y

  if [[ -z $value && -z $is_optional && -n $is_dynamic ]]; then
    _clint_error "missing parameter - \"$name\""
  fi

  if [[ -n $is_soak ]]; then
    CLINT_FLAGS[parameter_soak]=y
  elif [[ -n $is_dynamic ]]; then
    CLINT_PARAMETER_VALUES["$name"]="$value"
    CLINT_ARGV=("${CLINT_ARGV[@]:1}")
  fi
}
