#!/usr/bin/env bash

set -euo pipefail

fail() {
  printf 'image test failed: %s\n' "$1" >&2
  exit 1
}

[[ "$(id -u)" == "10001" ]] || fail "expected UID 10001, got $(id -u)"
[[ "$(id -g)" == "10001" ]] || fail "expected GID 10001, got $(id -g)"
[[ "${JAVA_HOME}" == "/usr/local/java/current" ]] || fail "unexpected JAVA_HOME"
test -x "${JAVA_HOME}/bin/java" || fail "Java binary is missing"
java --version 2>&1 | grep -q '25\.0\.3' || fail "unexpected Java version"
keytool -help >/dev/null 2>&1 || fail "keytool is unavailable"
java -XshowSettings:properties -version 2>&1 | grep -q 'java.home = /usr/local/java/current' || fail "unexpected java.home"
