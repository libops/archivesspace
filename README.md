# ArchivesSpace Docker Template

LibOps Docker Compose template for running [ArchivesSpace](https://archivesspace.org/) with Traefik, MariaDB, Solr, and the LibOps ArchivesSpace image.

## Requirements

- `sitectl` installed on the host that will run the site.
- Docker with the Compose v2 plugin installed on the same host.

## Quick start

Create a new ArchivesSpace site from this template:

```bash
sitectl create archivesspace/default \
  --template-repo https://github.com/libops/archivesspace \
  --path ./my-archivesspace-site \
  --type local \
  --checkout-source template \
  --default-context
```

The default public routes are:

- Public interface: `http://localhost/`
- Staff interface: `http://localhost/staff/`
- Backend API: `http://localhost/api/`

## Basic operations with sitectl

Run these from the generated checkout, or add `--context <name>` when operating from elsewhere.

```bash
# Start or update the Compose stack
sitectl compose up --remove-orphans -d

# Check the site and context configuration
sitectl healthcheck
sitectl validate

# Update image tags or pin a full image reference
sitectl image set --tag archivesspace=3.5.1 --tag solr=9
sitectl image set --image archivesspace=libops/archivesspace:3.5.1@sha256:...

# Enable local development bind mounts
sitectl set dev-mode enabled
sitectl converge

# Switch TLS modes
sitectl traefik tls mkcert --domain archivesspace.localhost
sitectl traefik tls letsencrypt --email ops@example.org

# Trust an upstream load balancer or reverse proxy
sitectl set reverse-proxy enabled --trusted-ip 203.0.113.10/32
sitectl converge
```

See the [ArchivesSpace sitectl plugin docs](https://github.com/libops/sitectl-docs/blob/main/plugins/archivesspace.mdx) for API helpers, resource shortcuts, container scripts, lifecycle operations, and rollout details.

## Makefile

The Makefile is intentionally small. It only keeps template-specific targets that are not core sitectl operations:

```bash
make rollout
make test
make lint
```

Use `sitectl compose ...`, `sitectl traefik ...`, and `sitectl set ...` directly for normal stack operations.

## Template notes

- `traefik` owns HTTP ingress.
- `archivesspace` builds this template on top of the LibOps ArchivesSpace image.
- `mariadb` is the application database.
- `solr` builds a small local image from the LibOps Solr base and downloads the ArchivesSpace Solr configset during image build.
- `config/config.rb` is baked into the template image.
- `plugins`, `locales`, and `stylesheets` are checked-in customization points for downstream repositories.

ArchivesSpace runtime settings are configured in `config/config.rb`. The application database password is read from `/run/secrets/ARCHIVESSPACE_DB_PASSWORD`, while MariaDB uses `/run/secrets/DB_ROOT_PASSWORD`.
