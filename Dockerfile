ARG BASE_IMAGE=libops/archivesspace:4.2.0
FROM ${BASE_IMAGE}

# archivesspace:archivesspace in the base image.
COPY --link --chown=1000:1000 config/ /archivesspace/config/
COPY --link --chown=1000:1000 plugins/ /archivesspace/plugins/
COPY --link --chown=1000:1000 locales/ /archivesspace/locales/
COPY --link --chown=1000:1000 stylesheets/ /archivesspace/stylesheets/
