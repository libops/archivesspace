ARG BASE_IMAGE=libops/archivesspace:4.2.0
FROM ${BASE_IMAGE}

COPY --link config/ /archivesspace/config/
COPY --link plugins/ /archivesspace/plugins/
COPY --link locales/ /archivesspace/locales/
COPY --link stylesheets/ /archivesspace/stylesheets/

RUN chown -R archivesspace:archivesspace \
    /archivesspace/config \
    /archivesspace/plugins \
    /archivesspace/locales \
    /archivesspace/stylesheets && \
    cleanup.sh
