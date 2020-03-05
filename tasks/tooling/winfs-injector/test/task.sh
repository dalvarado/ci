#!/bin/bash -eu

function main() {
  local cwd
  cwd="${1}"

  export GOPATH="${cwd}/go"

  pushd "${GOPATH}/src/github.com/pivotal-cf/winfs-injector" > /dev/null
    ginkgo \
      -r \
      -race \
      -succinct \
      -randomizeAllSpecs \
      -randomizeSuites \
      -failOnPending \
      .
  popd > /dev/null
}

main "${PWD}"
