ARG JAVA_IMAGE=openjdk:jre-alpine

FROM $JAVA_IMAGE

LABEL org.opencontainers.image.source="https://github.com/fluxapps/flux-ilias-ilserver-base"
LABEL maintainer="fluxlabs <support@fluxlabs.ch> (https://fluxlabs.ch)"

COPY . /flux-ilias-ilserver-base

ENTRYPOINT ["/flux-ilias-ilserver-base/bin/entrypoint.sh"]

ENV ILIAS_COMMON_CLIENT_ID default
ENV ILIAS_FILESYSTEM_DATA_DIR /var/iliasdata
ENV ILIAS_FILESYSTEM_INI_PHP_FILE $ILIAS_FILESYSTEM_DATA_DIR/ilias.ini.php
ENV ILIAS_WEB_DIR /var/www/html

ENV ILIAS_ILSERVER_INDEX_MAX_FILE_SIZE 500
ENV ILIAS_ILSERVER_INDEX_PATH $ILIAS_FILESYSTEM_DATA_DIR/ilserver
ENV ILIAS_ILSERVER_IP_ADDRESS 0.0.0.0
ENV ILIAS_ILSERVER_LOG_FILE /dev/stdout
ENV ILIAS_ILSERVER_LOG_LEVEL INFO
ENV ILIAS_ILSERVER_NIC_ID 0
ENV ILIAS_ILSERVER_NUM_THREADS 1
ENV ILIAS_ILSERVER_PORT 11111
ENV ILIAS_ILSERVER_PROPERTIES_PATH=$ILIAS_FILESYSTEM_DATA_DIR/ilserver.properties
ENV ILIAS_ILSERVER_RAM_BUFFER_SIZE 256

VOLUME $ILIAS_FILESYSTEM_DATA_DIR

EXPOSE $ILIAS_ILSERVER_PORT
