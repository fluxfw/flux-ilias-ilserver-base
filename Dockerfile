ARG JAVA_IMAGE=openjdk:jre-alpine

FROM $JAVA_IMAGE

LABEL org.opencontainers.image.source="https://github.com/fluxapps/flux-ilias-ilserver-base"
LABEL maintainer="fluxlabs <support@fluxlabs.ch> (https://fluxlabs.ch)"

COPY . /flux-ilias-ilserver-base

ENTRYPOINT ["/flux-ilias-ilserver-base/bin/entrypoint.sh"]

ENV ILIAS_WEB_DIR /var/www/html

ENV ILIAS_FILESYSTEM_DATA_DIR /var/iliasdata
RUN mkdir -p "$ILIAS_FILESYSTEM_DATA_DIR"
VOLUME $ILIAS_FILESYSTEM_DATA_DIR

ENV ILIAS_ILSERVER_PORT 11111
EXPOSE $ILIAS_ILSERVER_PORT
