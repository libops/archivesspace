#!/usr/bin/env bash

set -euo pipefail

./scripts/init.sh

service="${COMPOSE_SERVICE:-archivesspace}"

if command -v hadolint >/dev/null 2>&1 && find . -name Dockerfile -print -quit | grep -q .; then
  find . -name Dockerfile -exec hadolint {} +
else
  echo "hadolint not found or no Dockerfile present, skipping Dockerfile validation"
fi

if command -v json5 >/dev/null 2>&1 && [ -f renovate.json5 ]; then
  json5 --validate renovate.json5 >/dev/null
else
  echo "json5 not found or renovate.json5 missing, skipping renovate validation"
fi

shell_paths=(scripts)
if [ -d rootfs ]; then
  shell_paths+=(rootfs)
fi

if command -v shellcheck >/dev/null 2>&1; then
  find "${shell_paths[@]}" -name "*.sh" -exec shellcheck {} +
else
  find "${shell_paths[@]}" -name "*.sh" -exec bash -n {} +
fi

docker compose build --pull "${service}"
image_ref="$(docker compose build --print "${service}" | jq -er --arg service "${service}" '.target[$service].tags[0]')"
image_id="$(docker image inspect --format '{{.Id}}' "${image_ref}")"
if [ -z "${image_id}" ]; then
  echo "Could not resolve the built image for Compose service ${service}" >&2
  exit 1
fi

docker run --rm \
  --volume "${PWD}:/workspace:ro" \
  --workdir /workspace \
  --entrypoint sh \
  "${image_id}" \
  -lc '
    set -eu

    if ! command -v ruby >/dev/null 2>&1; then
      echo "Ruby executable not found in image; skipping Ruby and ERB syntax lint."
      exit 0
    fi

    ruby_files="$(find plugins config -type f -name "*.rb" 2>/dev/null || true)"
    if [ -z "${ruby_files}" ]; then
      echo "No custom ArchivesSpace Ruby files found; skipping Ruby syntax lint."
    else
      printf "%s\n" "${ruby_files}" | while IFS= read -r file; do
        ruby -c "${file}"
      done
    fi

    erb_files="$(find plugins config -type f -name "*.erb" 2>/dev/null || true)"
    if [ -z "${erb_files}" ]; then
      echo "No custom ArchivesSpace ERB files found; skipping ERB syntax lint."
    else
      printf "%s\n" "${erb_files}" | while IFS= read -r file; do
        ruby -rerb -e "ERB.new(File.read(ARGV[0])).src" "${file}" >/dev/null
      done
    fi
  '
