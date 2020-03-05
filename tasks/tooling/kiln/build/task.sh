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

  export GITHUB_TOKEN="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDbyS1icKmLvvAfBlIkrz2Cave70MR1xDU6mdTYY/gtOZTo+8WpJFc9V2Ql3gfGFKTnzkvZSgWZiB5HaMBDeTnn6YSCR2WyAbdXyhBkJLARpohzp9jFKx/hYRCmcYTC004B0WFnmFl5XQienCevJqONTLlLAWZTH4UKyrnp6GmXAUfJQ3wDTnBA+WUxtyGFbjIbY6Y3fntXYdljRinAd/Kd0DuYR5Opo7bz0RmWVlFM1JuGT1nC0kiDtX/J+gayE+yXMF1lVUnnbEu1r7vz5Kiy0fn+1BjT2H3/ATPsUtk3Zrv56jgpi/QBNUw+eFTHSt9tuDwx9qRFVyMYUCxJ5QCH"

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
    source .envrc
    goreleaser release
  popd > /dev/null
}

main "${PWD}"
