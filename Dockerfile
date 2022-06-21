ARG JAVA_VERSION

FROM alpine:latest AS build

COPY . /build/flux-ilias-ilserver-base

RUN (cd /build && tar -czf flux-ilias-ilserver-base.tar.gz flux-ilias-ilserver-base)

FROM openjdk:$JAVA_VERSION-jre-alpine

LABEL org.opencontainers.image.source="https://github.com/flux-caps/flux-ilias-ilserver-base"
LABEL maintainer="fluxlabs <support@fluxlabs.ch> (https://fluxlabs.ch)"

RUN getent group www-data || addgroup -g 82 www-data && adduser -u 82 -D -S -G www-data www-data

ENV ILIAS_WEB_DIR /var/www/html
RUN mkdir -p "$ILIAS_WEB_DIR" && chown www-data:www-data -R "$ILIAS_WEB_DIR"

ENV ILIAS_ILSERVER_DATA_DIR /var/ilserverdata
RUN mkdir -p "$ILIAS_ILSERVER_DATA_DIR" && chown www-data:www-data -R "$ILIAS_ILSERVER_DATA_DIR"
VOLUME $ILIAS_ILSERVER_DATA_DIR

ENV ILIAS_FILESYSTEM_DATA_DIR /var/iliasdata
RUN mkdir -p "$ILIAS_FILESYSTEM_DATA_DIR" && chown www-data:www-data -R "$ILIAS_FILESYSTEM_DATA_DIR"
VOLUME $ILIAS_FILESYSTEM_DATA_DIR

USER www-data:www-data

ENV ILIAS_ILSERVER_INDEX_PATH $ILIAS_ILSERVER_DATA_DIR/index
RUN mkdir -p "$ILIAS_ILSERVER_INDEX_PATH"

ENV ILIAS_ILSERVER_PORT 11111
EXPOSE $ILIAS_ILSERVER_PORT

ENTRYPOINT ["/flux-ilias-ilserver-base/bin/docker-entrypoint.sh"]

COPY --from=build /build /

ARG COMMIT_SHA
LABEL org.opencontainers.image.revision="$COMMIT_SHA"
