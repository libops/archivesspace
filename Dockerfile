ARG BASE_IMAGE=libops/archivesspace:4.2.0@sha256:c9d5a0e17b941ef712f0086f8460094459bd0acd83e68829d184642ab32f3ecb
FROM ${BASE_IMAGE}

# archivesspace:archivesspace in the base image.
COPY --link --chown=1000:1000 config/ /archivesspace/config/
COPY --link --chown=1000:1000 plugins/ /archivesspace/plugins/
COPY --link --chown=1000:1000 locales/ /archivesspace/locales/
COPY --link --chown=1000:1000 stylesheets/ /archivesspace/stylesheets/
