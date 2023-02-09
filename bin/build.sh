#!/usr/bin/env sh

set -e

bin="`dirname "$0"`"
root="$bin/.."

name="`basename "$(realpath "$root")"`"
user="${FLUX_PUBLISH_DOCKER_USER:=fluxfw}"
image="$user/$name"

for java_version in 8; do
    docker build "$root" --pull --build-arg JAVA_VERSION=$java_version -t "$image:java$java_version"
done
docker tag "$image:java8" "$image:latest"
