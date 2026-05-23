#!/usr/bin/env bash

set -euo pipefail

if [ ! -f .env ]; then
  cp sample.env .env
fi

./scripts/generate-secrets.sh
