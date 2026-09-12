ARG BASE_IMAGE=libops/archivesspace:4.2.1@sha256:a440300ed67f2e354ee3c31d1fbeac7c07adf8025f34d90ee1b0d3b3c51a8eb9
FROM ${BASE_IMAGE}

# archivesspace:archivesspace in the base image.
COPY --link --chown=1000:1000 config/ /archivesspace/config/
COPY --link --chown=1000:1000 plugins/ /archivesspace/plugins/
COPY --link --chown=1000:1000 locales/ /archivesspace/locales/
COPY --link --chown=1000:1000 stylesheets/ /archivesspace/stylesheets/
