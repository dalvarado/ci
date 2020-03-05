#!/bin/bash 

set -euo pipefail

: "${NAME:?}"
: "${VERSION:?}"

function main() {
  local cwd dir

  cwd="${1:?}"
  dir="$(mktemp -d)"

  bosh init-release --dir "$dir"
  cd "$dir"
  bosh generate-job sample-job
  bosh create-release \
    --tarball="${cwd}/release-tarball/${NAME}-${VERSION}.tgz" \
    --name="${NAME}" \
    --version="${VERSION}"
}

main "$PWD"
