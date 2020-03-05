#!/bin/bash

set -euo pipefail

: "${KILN_ACCEPTANCE_VARS_FILE_CONTENTS:?}"
: "${PIVNET_TOKEN:?}"
: "${PRODUCT_DIRECTORY:?}"

function main() {
  chown -R testuser:testuser "${GOPATH}"
  chown -R testuser:testuser /root

  export PRODUCT_DIRECTORY="${PWD}/${PRODUCT_DIRECTORY}"
  echo "PRODUCT_DIRECTORY prepended with current directory: PRODUCT_DIRECTORY=${PRODUCT_DIRECTORY}"

  echo "the ${PRODUCT_DIRECTORY} contents are:"
  ls -la "${PRODUCT_DIRECTORY}"

  pushd kiln
    RUN_INTEGRATION_TESTS=true chpst -u testuser:testuser ginkgo \
      -v \
      -r \
      -succinct \
      -race \
      -randomizeAllSpecs \
      -randomizeSuites \
      -failOnPending \
      acceptance/integration
  popd
}

main
