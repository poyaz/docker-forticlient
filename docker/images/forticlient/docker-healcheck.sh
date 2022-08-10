#!/usr/bin/env bash
set -Eeo pipefail

file_env() {
  local var="$1"
  local fileVar="${var}_FILE"
  local def="${2:-}"
  if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
    echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
    exit 1
  fi
  local val="$def"
  if [ "${!var:-}" ]; then
    val="${!var}"
  elif [ "${!fileVar:-}" ]; then
    val="$(<"${!fileVar}")"
  fi
  export "$var"="$val"
  unset "$fileVar"
}

docker_setup_env() {
  file_env 'VPN_INTERFACE_NAME' 'ppp0'
}

check_vpn_interface_exist() {
  declare -r RES=$(ip -o a show | cut -d ' ' -f 2 | grep "$VPN_INTERFACE_NAME")
  if [ -z "$RES" ]; then
    echo "[ERR] The interface \"$VPN_INTERFACE_NAME\" not found!"
    exit 1
  fi
}

_main() {
  docker_setup_env

  check_vpn_interface_exist
}

_main "$@"
