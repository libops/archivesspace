ARG BASE_IMAGE=libops/archivesspace:4.2.0@sha256:26089a627a043e068901c69d3339415ebba94713d5e19327808f95b6a2efc9ea
FROM ${BASE_IMAGE}

# archivesspace:archivesspace in the base image.
COPY --link --chown=1000:1000 config/ /archivesspace/config/
COPY --link --chown=1000:1000 plugins/ /archivesspace/plugins/
COPY --link --chown=1000:1000 locales/ /archivesspace/locales/
COPY --link --chown=1000:1000 stylesheets/ /archivesspace/stylesheets/
