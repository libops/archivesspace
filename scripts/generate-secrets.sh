#!/usr/bin/env bash

set -euo pipefail

random_secret() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex 32
    return
  fi

  od -An -N32 -tx1 /dev/urandom | tr -d ' \n'
}

generate_secret_file() {
  local secret_file="$1"
  local mode="${2:-0600}"

  if [ ! -s "${secret_file}" ]; then
    echo "Creating: ${secret_file}" >&2
    install -d -m 0700 "$(dirname "${secret_file}")"
    umask 077
    random_secret > "${secret_file}"
  fi
  chmod "${mode}" "${secret_file}"
}

generate_secret_file ./secrets/DB_ROOT_PASSWORD
generate_secret_file ./secrets/ARCHIVESSPACE_DB_PASSWORD 0644
