#!/bin/bash -eu

function main() {
  local cwd
  cwd="${1}"

  pushd "${cwd}/kiln" > /dev/null
    source .envrc

    ./example-tile/build.sh
  popd > /dev/null
}

main "${PWD}"
