#!/bin/sh
# Usage: PREFIX=/usr/local ./install.sh
#
# Installs pyenv-virtualenv under $PREFIX.

set -e

cd "$(dirname "$0")"

if [ -z "${PREFIX}" ]; then
  PREFIX="/usr/local"
fi

ETC_PATH="${PREFIX}/etc/pyenv.d"
LIBEXEC_PATH="${PREFIX}/libexec"

mkdir -p "$ETC_PATH"
mkdir -p "$LIBEXEC_PATH"

cp -RPp etc/pyenv.d/* "$ETC_PATH"
install -p libexec/* "$LIBEXEC_PATH"
