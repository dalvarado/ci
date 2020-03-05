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

  export GITHUB_TOKEN=554a9f09e2248696b71ddbef2a9d8015c19f9df2 

  if [ -z "$GITHUB_TOKEN" ]; then
    echo "GITHUB_TOKEN is required"
    exit 1
  fi

  cd ../

  local cwd
  cwd="${1}"

  local version
  version="$(cat kiln-version/version)"

  export GOPATH="${cwd}/go"
  pushd "${GOPATH}/src/github.com/dalvarado/kiln" > /dev/null
    git tag -a -f ${version} HEAD -m "new version - ${version}"
    source .envrc
    goreleaser release
  popd > /dev/null
}

main "${PWD}"
