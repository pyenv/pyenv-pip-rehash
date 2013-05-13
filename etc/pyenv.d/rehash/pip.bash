##!/usr/bin/env bash

SHIM_PATH="${PYENV_ROOT}/shims"
PIP_SHIM_PATH="${SHIM_PATH}/.pip-shim"

# Create the shims directory if it doesn't already exist.
mkdir -p "$SHIM_PATH"

# Ensure only one instance of pyenv-rehash is running at a time by
# setting the shell's `noclobber` option and attempting to write to
# the pip shim file. If the file already exists, print a warning
# to stderr and exit with a non-zero status.
set -o noclobber
{ echo > "$PIP_SHIM_PATH"
} 2>/dev/null ||
{ echo "pyenv: cannot rehash: $PIP_SHIM_PATH exists"
  exit 1
} >&2
set +o noclobber

# If we were able to obtain a lock, register a trap to clean up the
# pip shim when the process exits.
trap remove_prototype_shim EXIT

# Override original `remove_prototype_shim`
remove_prototype_shim() {
  rm -f "$PROTOTYPE_SHIM_PATH"
  remove_pip_shim
}

remove_pip_shim() {
  rm -f "$PIP_SHIM_PATH"
}

# The pip shim file is a script that re-execs itself, passing
# its filename and any arguments to `pyenv exec`. This file is
# hard-linked for every executable and then removed. The linking
# technique is fast, uses less disk space than unique files, and also
# serves as a locking mechanism.
create_pip_shim() {
  cat > "$PIP_SHIM_PATH" <<SH
#!/usr/bin/env bash
set -e
[ -n "\$PYENV_DEBUG" ] && set -x

program="\${0##*/}"
if [ "\$program" = "python" ]; then
  for arg; do
    case "\$arg" in
    -c* | -- ) break ;;
    */* )
      if [ -f "\$arg" ]; then
        export PYENV_DIR="\${arg%/*}"
        break
      fi
      ;;
    esac
  done
fi

export PYENV_ROOT="$PYENV_ROOT"
STATUS=0
"$(command -v pyenv)" exec "\$program" "\$@" || STATUS=\$?
if [ "\$1" = "install" ] || [ "\$1" = "uninstall" ]; then
  "$(command -v pyenv)" rehash
fi
exit "\$STATUS"
SH
  chmod +x "$PIP_SHIM_PATH"
}

install_pip_shims() {
  local shim
  for shim in "${registered_shims[@]}"; do
    ( [[ "$shim" == "pip"* ]] && ln -f "$PIP_SHIM_PATH" "$shim" ; true )
  done
}

# Change to the shims directory.
cd "$SHIM_PATH"
shopt -s nullglob

# Create the pip shim, then register shims for all known
# executables.
create_pip_shim
install_pip_shims
remove_pip_shim

# Restore the previous working directory.
cd "$OLDPWD"
