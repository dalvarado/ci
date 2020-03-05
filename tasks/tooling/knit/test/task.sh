#!/bin/bash -eu

function main() {
  local cwd
  cwd="${1}"

  export GOPATH="${cwd}/go"
  chown -R testuser:testuser "${GOPATH}"
  chown -R testuser:testuser /root

  pushd "${GOPATH}/src/github.com/pivotal-cf/knit" > /dev/null
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
