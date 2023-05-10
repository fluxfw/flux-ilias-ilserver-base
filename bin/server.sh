#!/usr/bin/env sh

set -e

checkWwwData() {
    if test -w "$1"; then
        echo "true"
    else
        echo "false"
    fi
}

ensureWwwData() {
    mkdir -p "$1"
    until [ `checkWwwData "$1"` = "true" ]; do
        echo "www-data can not write to $1"
        echo "Please manually run the follow command like"
        echo "docker exec -u root:root `hostname` chown www-data:www-data -R $1"
        echo "Waiting 30 seconds for check again"
        sleep 30
    done
    echo "www-data can write to $1"
}

ILIAS_COMMON_CLIENT_ID="${ILIAS_COMMON_CLIENT_ID:=default}"

ILIAS_FILESYSTEM_INI_PHP_FILE="${ILIAS_FILESYSTEM_INI_PHP_FILE:=$ILIAS_FILESYSTEM_DATA_DIR/ilias.ini.php}"

ILIAS_ILSERVER_INDEX_MAX_FILE_SIZE="${ILIAS_ILSERVER_INDEX_MAX_FILE_SIZE:=500}"
ILIAS_ILSERVER_IP_ADDRESS="${ILIAS_ILSERVER_IP_ADDRESS:=0.0.0.0}"
ILIAS_ILSERVER_LOG_FILE="${ILIAS_ILSERVER_LOG_FILE:=/dev/stdout}"
ILIAS_ILSERVER_LOG_LEVEL="${ILIAS_ILSERVER_LOG_LEVEL:=INFO}"
ILIAS_ILSERVER_NIC_ID="${ILIAS_ILSERVER_NIC_ID:=0}"
ILIAS_ILSERVER_NUM_THREADS="${ILIAS_ILSERVER_NUM_THREADS:=1}"
ILIAS_ILSERVER_PORT="${ILIAS_ILSERVER_PORT:=11111}"
ILIAS_ILSERVER_PROPERTIES_PATH="${ILIAS_ILSERVER_PROPERTIES_PATH:=$ILIAS_ILSERVER_DATA_DIR/ilserver.properties}"
ILIAS_ILSERVER_RAM_BUFFER_SIZE="${ILIAS_ILSERVER_RAM_BUFFER_SIZE:=256}"

if [ ! -f "$ILIAS_WEB_DIR/ilias.php" ]; then
    echo "Please provide ILIAS source code to $ILIAS_WEB_DIR"
    exit 1
fi

ensureWwwData "$ILIAS_ILSERVER_DATA_DIR"
ensureWwwData "$ILIAS_ILSERVER_INDEX_PATH"

if [ -f "$ILIAS_FILESYSTEM_INI_PHP_FILE" ]; then
    echo "ILIAS config found"
else
    echo "ILIAS not configured yet"
    exit 1
fi

echo "Generate ilserver config"
echo "[Server]
IndexMaxFileSizeMB = $ILIAS_ILSERVER_INDEX_MAX_FILE_SIZE
IndexPath = $ILIAS_ILSERVER_INDEX_PATH
IpAddress = $ILIAS_ILSERVER_IP_ADDRESS
LogFile = $ILIAS_ILSERVER_LOG_FILE
LogLevel = $ILIAS_ILSERVER_LOG_LEVEL
NumThreads = $ILIAS_ILSERVER_NUM_THREADS
Port = $ILIAS_ILSERVER_PORT
RamBufferSize = $ILIAS_ILSERVER_RAM_BUFFER_SIZE
[Client1]
ClientId = $ILIAS_COMMON_CLIENT_ID
IliasIniPath = $ILIAS_FILESYSTEM_INI_PHP_FILE
NicId = $ILIAS_ILSERVER_NIC_ID" > "$ILIAS_ILSERVER_PROPERTIES_PATH"

echo "Start ilserver"
exec java -jar "$ILIAS_WEB_DIR/Services/WebServices/RPC/lib/ilServer.jar" "$ILIAS_ILSERVER_PROPERTIES_PATH" start
