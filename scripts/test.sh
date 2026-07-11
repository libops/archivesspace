#!/usr/bin/env bash

set -eou pipefail

./scripts/init.sh
docker compose build --pull archivesspace
docker compose up --remove-orphans --wait --wait-timeout "${COMPOSE_WAIT_TIMEOUT:-600}"

http_port="$(docker compose port traefik 80 | awk -F: 'END {print $NF}')"
http_port="${http_port:-80}"

curl -fsS "http://localhost:${http_port}/" >/dev/null
curl -fsS "http://localhost:${http_port}/staff/" >/dev/null
