ARG BASE_IMAGE=libops/archivesspace:4.2.0@sha256:4082d760cac3fa1c73ee74abf16f83e30560f55a91c5eed8770d365b7df411d3
FROM ${BASE_IMAGE}

# archivesspace:archivesspace in the base image.
COPY --link --chown=1000:1000 config/ /archivesspace/config/
COPY --link --chown=1000:1000 plugins/ /archivesspace/plugins/
COPY --link --chown=1000:1000 locales/ /archivesspace/locales/
COPY --link --chown=1000:1000 stylesheets/ /archivesspace/stylesheets/
