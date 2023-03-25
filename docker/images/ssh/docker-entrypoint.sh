#!/usr/bin/env bash
set -Eeo pipefail

declare -r SSH_USER_USERNAME=forti

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
  file_env 'SSH_USER_PASSWORD'
  file_env 'SSH_PUBLIC_KEY_VALUE'
}

sshd_config_file() {
  #  mkdir -p /run/sshd
  #  chown $SSH_USER_USERNAME:$SSH_USER_USERNAME /run/sshd
  #
  #  sed -i s/#PidFile.*/PidFile\ \\/run\\/sshd\\/sshd.pid/ /etc/ssh/sshd_config

  sed -i s/#*AllowTcpForwarding.*/AllowTcpForwarding\ yes/ /etc/ssh/sshd_config
}

generate_host_keys() {
  ssh-keygen -A
}

sshd_set_password() {
  local password

  if [ -z "$SSH_USER_PASSWORD" ]; then
      password=$(echo $RANDOM | md5sum | head -c 20; echo;)
  else
      password=$SSH_USER_PASSWORD
  fi

  echo "$SSH_USER_USERNAME:$password" | chpasswd
}

sshd_set_public_key() {
  if [ -z "$SSH_PUBLIC_KEY_VALUE" ]; then
    return
  fi

  declare -r AUTHORIZED_KEYS_FILE="/home/$SSH_USER_USERNAME/.ssh/authorized_keys"

  if ! [ -f "$AUTHORIZED_KEYS_FILE" ]; then
    touch "$AUTHORIZED_KEYS_FILE"
  fi

  chmod 600 "$AUTHORIZED_KEYS_FILE"
  chown $SSH_USER_USERNAME:$SSH_USER_USERNAME "$AUTHORIZED_KEYS_FILE"

  grep -q -F "$SSH_PUBLIC_KEY_VALUE" "$AUTHORIZED_KEYS_FILE" 2>/dev/null || echo "$SSH_PUBLIC_KEY_VALUE" >>"$AUTHORIZED_KEYS_FILE"
}

run_sshd() {
  exec /usr/sbin/sshd -D -e "$@"
}

_main() {
  if [ $1 = 'sshd' ]; then
    docker_setup_env

    sshd_config_file

    sshd_set_password

    generate_host_keys

    sshd_set_public_key

    run_sshd "${@:2}"
  fi

  exec "$@"
}

_main "$@"
