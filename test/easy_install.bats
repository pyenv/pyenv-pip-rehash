#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_PIP_REHASH_ROOT="$(abs_dirname "${BATS_TEST_DIRNAME}/../..")"
  stub pyenv-which "easy_install : echo \"${TMP}/bin/easy_install\"" \
                   "easy_install : echo \"${TMP}/bin/easy_install\""
}

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

@test "should invoke rehash after successful easy_install" {
  stub pyenv-rehash "echo rehashed"
  stub easy_install "echo \"easy_install \$@\""

  run pyenv-exec easy_install tornado

  unstub pyenv-rehash
  unstub easy_install

  assert_success
  assert_output <<EOS
PYENV_BIN_PATH=${PYENV_PIP_REHASH_ROOT}/libexec exec -a easy_install ${PYENV_PIP_REHASH_ROOT}/libexec/easy_install tornado
easy_install tornado
rehashed
EOS
}

@test "should not invoke rehash after unsuccessful easy_install" {
  stub easy_install "echo \"easy_install \$@\"; false"

  run pyenv-exec easy_install -U tornado

  unstub easy_install

  assert_failure
  assert_output <<EOS
PYENV_BIN_PATH=${PYENV_PIP_REHASH_ROOT}/libexec exec -a easy_install ${PYENV_PIP_REHASH_ROOT}/libexec/easy_install -U tornado
easy_install -U tornado
EOS
}
