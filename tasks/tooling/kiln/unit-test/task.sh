#!/bin/bash -eu

function main() {
  local cwd
  cwd="${1}"

  chown -R testuser:testuser "${GOPATH}"
  chown -R testuser:testuser /root

  pushd "${cwd}/kiln" > /dev/null
    source .envrc

    chpst -u testuser:testuser ginkgo \
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
