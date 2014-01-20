#!/bin/sh
# Usage: PREFIX=/usr/local ./install.sh
#
# Installs pyenv-virtualenv under $PREFIX.

set -e

cd "$(dirname "$0")"

if [ -z "${PREFIX}" ]; then
  PREFIX="/usr/local"
fi

LIBEXEC_PATH="${PREFIX}/libexec"

mkdir -p "$LIBEXEC_PATH"

install -p libexec/* "$LIBEXEC_PATH"
