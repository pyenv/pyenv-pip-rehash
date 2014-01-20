#!/usr/bin/env bats

load test_helper

setup() {
  export PYENV_PIP_REHASH_ROOT="$(abs_dirname "${BATS_TEST_DIRNAME}/../..")"
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

@test "should not invoke rehash after pip freeze" {
  stub pyenv-which "pip : echo \"${TMP}/bin/pip\"" \
                   "pip : echo \"${TMP}/bin/pip\""
  stub pip "echo \"pip \$@\""

  run pyenv-exec pip freeze

  unstub pyenv-which
  unstub pip

  assert_success
  assert_output <<EOS
PYENV_BIN_PATH=${PYENV_PIP_REHASH_ROOT}/libexec exec -a pip ${PYENV_PIP_REHASH_ROOT}/libexec/pip freeze
pip freeze
EOS
}

@test "should invoke rehash after successful pip install" {
  stub pyenv-which "pip : echo \"${TMP}/bin/pip\"" \
                   "pip : echo \"${TMP}/bin/pip\""
  stub pyenv-rehash "echo rehashed"
  stub pip "echo \"pip \$@\""

  run pyenv-exec pip install -U tornado

  unstub pyenv-which
  unstub pyenv-rehash
  unstub pip

  assert_success
  assert_output <<EOS
PYENV_BIN_PATH=${PYENV_PIP_REHASH_ROOT}/libexec exec -a pip ${PYENV_PIP_REHASH_ROOT}/libexec/pip install -U tornado
pip install -U tornado
rehashed
EOS
}

@test "should invoke rehash after unsuccessful pip install" {
  stub pyenv-which "pip : echo \"${TMP}/bin/pip\"" \
                   "pip : echo \"${TMP}/bin/pip\""
  stub pip "echo \"pip \$@\"; false"

  run pyenv-exec pip install tornado

  unstub pyenv-which
  unstub pip

  assert_failure
  assert_output <<EOS
PYENV_BIN_PATH=${PYENV_PIP_REHASH_ROOT}/libexec exec -a pip ${PYENV_PIP_REHASH_ROOT}/libexec/pip install tornado
pip install tornado
EOS
}

@test "should invoke rehash after successful pip uninstall" {
  stub pyenv-which "pip : echo \"${TMP}/bin/pip\"" \
                   "pip : echo \"${TMP}/bin/pip\""
  stub pyenv-rehash "echo rehashed"
  stub pip "echo \"pip \$@\""

  run pyenv-exec pip uninstall --yes tornado

  unstub pyenv-which
  unstub pyenv-rehash
  unstub pip

  assert_success
  assert_output <<EOS
PYENV_BIN_PATH=${PYENV_PIP_REHASH_ROOT}/libexec exec -a pip ${PYENV_PIP_REHASH_ROOT}/libexec/pip uninstall --yes tornado
pip uninstall --yes tornado
rehashed
EOS
}

@test "should not invoke rehash after unsuccessful pip uninstall" {
  stub pyenv-which "pip : echo \"${TMP}/bin/pip\"" \
                   "pip : echo \"${TMP}/bin/pip\""
  stub pip "echo \"pip \$@\"; false"

  run pyenv-exec pip uninstall tornado

  unstub pyenv-which
  unstub pip

  assert_failure
  assert_output <<EOS
PYENV_BIN_PATH=${PYENV_PIP_REHASH_ROOT}/libexec exec -a pip ${PYENV_PIP_REHASH_ROOT}/libexec/pip uninstall tornado
pip uninstall tornado
EOS
}

@test "should invoke rehash after successful easy_install" {
  stub pyenv-which "easy_install : echo \"${TMP}/bin/easy_install\"" \
                   "easy_install : echo \"${TMP}/bin/easy_install\""
  stub pyenv-rehash "echo rehashed"
  stub easy_install "echo \"easy_install \$@\""

  run pyenv-exec easy_install tornado

  unstub pyenv-which
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
  stub pyenv-which "easy_install : echo \"${TMP}/bin/easy_install\"" \
                   "easy_install : echo \"${TMP}/bin/easy_install\""
  stub easy_install "echo \"easy_install \$@\"; false"

  run pyenv-exec easy_install -U tornado

  unstub pyenv-which
  unstub easy_install

  assert_failure
  assert_output <<EOS
PYENV_BIN_PATH=${PYENV_PIP_REHASH_ROOT}/libexec exec -a easy_install ${PYENV_PIP_REHASH_ROOT}/libexec/easy_install -U tornado
easy_install -U tornado
EOS
}
