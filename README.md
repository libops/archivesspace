# ArchivesSpace Docker Template

LibOps-owned Docker Compose template for ArchivesSpace.

## Quick Start

```bash
make up
```

Traefik is the only ingress:

- Public interface: `http://localhost/`
- Staff interface: `http://localhost/staff/`
- Backend API: `http://localhost/api/`

`make up` runs `scripts/init.sh`, which creates `.env` from `sample.env` when needed and generates missing Docker secret files under `secrets/`.

## Layout

- `traefik` owns HTTP ingress.
- `archivesspace` builds this template on top of the LibOps ArchivesSpace image.
- `mariadb` is the only database service.
- `solr` builds a small local image from the LibOps Solr base and downloads the ArchivesSpace Solr configset during image build.
- `config/config.rb` is baked into the template image.
- `plugins`, `locales`, and `stylesheets` are checked-in customization points for downstream repos.

`docker-compose.yaml` is the production-shaped default. Local development changes should be copied from `docker-compose.override-example.yaml` to `docker-compose.override.yaml`; the example exposes MariaDB and Solr and includes optional bind mounts for local plugin, locale, and stylesheet editing.

Downstream repos bake customizations into their local image during `docker compose build`. The bind mounts in the override example are only for local development feedback loops.

## SMTP

ArchivesSpace runtime settings are configured in `config/config.rb`. The application database password is read from `/run/secrets/ARCHIVESSPACE_DB_PASSWORD`, while MariaDB uses `/run/secrets/DB_ROOT_PASSWORD`. `.env` is used only for non-secret Compose defaults.

By default, mail relays through `${SMTP_HOST:-host.docker.internal}:${SMTP_PORT:-25}` so production delivery can be handled by the host MTA and LibOps relay path. The override example adds Mailpit and points ArchivesSpace at `mailpit:1025` for local testing.

## Rollouts

`make rollout` runs `scripts/rollout.sh`, which checks out the requested git ref when provided, pulls images, runs init, and converges the Compose stack. ArchivesSpace database migrations are handled by startup with `ASPACE_DB_MIGRATE=true`.

## Updates

Renovate tracks:

- ArchivesSpace release downloads in buildkit.
- ArchivesSpace Solr configset downloads in `solr/Dockerfile`.
- LibOps base images for supporting services.
- Shared LibOps Renovate defaults through `github>libops/renovate-config`.
