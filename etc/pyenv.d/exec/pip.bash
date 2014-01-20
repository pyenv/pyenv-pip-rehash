##!/usr/bin/env bash

resolve_link() {
  $(type -p greadlink readlink | head -1) "$1"
}

abs_dirname() {
  local cwd="$(pwd)"
  local path="$1"

  while [ -n "$path" ]; do
    cd "${path%/*}"
    local name="${path##*/}"
    path="$(resolve_link "$name" || true)"
  done

  pwd
  cd "$cwd"
}

PYENV_PIP_REHASH_ROOT="$(abs_dirname "$(abs_dirname "${BASH_SOURCE[0]}")/../../../..")"

if [ -x "${PYENV_PIP_REHASH_ROOT}/libexec/${PYENV_COMMAND##*/}" ]; then
  PYENV_COMMAND_PATH="${PYENV_PIP_REHASH_ROOT}/libexec/${PYENV_COMMAND##*/}"
  PYENV_BIN_PATH="${PYENV_PIP_REHASH_ROOT}/libexec"
fi
