#!/bin/bash -eu

function main() {
  local cwd
  cwd="${1}"

  export GOPATH="${cwd}/go"

  # The p-runtime/bin directory does not contain ginkgo nor gomega for running the test suite.

  pushd "${GOPATH}" > /dev/null
    go get github.com/onsi/ginkgo
    go get github.com/onsi/gomega
  popd > /dev/null

  pushd "${GOPATH}/src/github.com/pivotal-cf/p-runtime" > /dev/null
    ginkgo \
      -r \
      -race \
      -succinct \
      -randomizeAllSpecs \
      -randomizeSuites \
      -failOnPending \
      bin
  popd > /dev/null
}

main "${PWD}"
