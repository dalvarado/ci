#!/bin/bash -eu

function main() {
  
  # clone it outside GOPATH
  git clone https://github.com/goreleaser/goreleaser
  cd goreleaser
  
  # get dependencies using go modules (needs go 1.11+)
  go get ./...
  
  # build
  go build -o goreleaser .
  
  # check it works
  ./goreleaser --version

  if [ -z "$GITHUB_TOKEN" ]; then
    echo "GITHUB_TOKEN is required"
    exit 1
  fi

  export KILN_VERSION="$(cat kiln-version/version)"

  local cwd
  cwd="${1}"

  local version
  version="$(cat kiln-version/version)"

  export GOPATH="${cwd}/go"
  pushd "${GOPATH}/src/github.com/dalvarado/kiln" > /dev/null
    source .envrc
    go version
    goreleaser release
    done
  popd > /dev/null
}

main "${PWD}"
