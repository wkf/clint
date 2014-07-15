
_clint_parse_usage() {
  echo "$1" | awk -F' ' '{$1=$2=""; gsub(" ","\n",$0); print substr($0,3)}'
}
