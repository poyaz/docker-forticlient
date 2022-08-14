#!/usr/bin/env bash
set -Eeo pipefail

trap "echo The script is terminated with SIGINT; exit" SIGINT
trap "echo The script is terminated with SIGTERM; exit" SIGTERM
trap "echo The script is terminated with SIGKILL; exit" SIGKILL

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

function docker_setup_env() {
  file_env 'VPN_ADDR'
  file_env 'VPN_USER'
  file_env 'VPN_PASS'
  file_env 'VPN_TIMEOUT' 30
  file_env 'VPN_2FA_DIR' '/tmp/2fa/'
  file_env 'VPN_2FA_FILE' '/tmp/2fa/2fa.txt'
}

check_require_variable_set() {
  if [ -z "$VPN_ADDR" -o -z "$VPN_USER" -o -z "$VPN_PASS" ]; then
    echo "Variables VPN_ADDR, VPN_USER and VPN_PASS must be set."
    exit 1
  fi

  if [ ! -d "$VPN_2FA_DIR" ]; then
    echo "The 2fa directory not exist. Please fill variable VPN_2FA_DIR with valid directory."
    exit 1
  fi
}

function run() {
  rm -f "${VPN_2FA_FILE}.lock" "$VPN_2FA_FILE"
  touch "$VPN_2FA_FILE"
  chmod 777 "$VPN_2FA_FILE"

  # Setup masquerade, to allow using the container as a gateway
  for iface in $(ip a | grep eth | grep inet | awk '{print $2}'); do
    iptables -t nat -A POSTROUTING -s "$iface" -j MASQUERADE
  done

  while [ true ]; do
    echo "------------ VPN Starts ------------"
    /usr/local/bin/forticlient
    echo "------------ VPN exited ------------"
    sleep 10
  done
}

_main() {
  docker_setup_env

  check_require_variable_set

  run
}

_main "$@"
