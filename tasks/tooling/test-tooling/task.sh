#!/bin/bash -eux


function main() {
  export GOPATH="${1}/go"
  chown -R testuser:testuser "${GOPATH}"
  chown -R testuser:testuser /root

  pushd "${GOPATH}/src/github.com/pivotal-cf/pcf-releng-ci" > /dev/null
    chpst -u testuser:testuser ginkgo \
      -r \
      -race \
      -succinct \
      -p \
      -randomizeAllSpecs \
      -randomizeSuites \
      ./tasks
  popd > /dev/null
}

main "${PWD}"
