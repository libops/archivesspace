#!/usr/bin/env bash

set -eou pipefail

./scripts/init.sh
docker compose up --remove-orphans -d

http_port="$(docker compose port traefik 80 | awk -F: 'END {print $NF}')"
http_port="${http_port:-80}"

curl -fsS "http://localhost:${http_port}/" >/dev/null
curl -fsS "http://localhost:${http_port}/staff/" >/dev/null
