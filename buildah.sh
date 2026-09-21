#!/usr/bin/env bash

set -euo pipefail

: "${CONTAINER_MOUNT:?CONTAINER_MOUNT must be set by the Buildah workflow}"
JAVA_MAJOR="25"
# renovate: datasource=github-releases depName=adoptium/temurin25-binaries extractVersion=^jdk-(?<version>.+)$
JAVA_VERSION="25.0.3+9"
JAVA_HOME="/usr/local/java/current"
for variable in JAVA_MAJOR JAVA_VERSION JAVA_HOME; do
  buildah config --env "${variable}=${!variable}" "${BASE_CONTAINER}"
done

JAVA_FEATURE_VERSION="${JAVA_VERSION%%+*}"
JAVA_BUILD="${JAVA_VERSION##*+}"
JRE_FILE="OpenJDK${JAVA_MAJOR}U-jre_x64_linux_hotspot_${JAVA_FEATURE_VERSION}_${JAVA_BUILD}.tar.gz"
JRE_URL="https://github.com/adoptium/temurin${JAVA_MAJOR}-binaries/releases/download/jdk-${JAVA_VERSION}/${JRE_FILE}"

mkdir -p "${CONTAINER_MOUNT}${JAVA_HOME}"
curl --fail --show-error --location --proto '=https' --tlsv1.2 --retry 3 \
  --output jre.tar.gz "${JRE_URL}"
tar -zxf jre.tar.gz -C "${CONTAINER_MOUNT}${JAVA_HOME}" --strip-components=1
rm -f jre.tar.gz

run_in_container_mount "
  ln -sf ${JAVA_HOME}/bin/java /usr/bin/java
  ln -sf ${JAVA_HOME}/bin/keytool /usr/bin/keytool
"
