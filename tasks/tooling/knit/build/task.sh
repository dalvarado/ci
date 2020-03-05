#!/bin/bash -eu

function main() {
  local cwd
  cwd="${1}"

  local version
  version="$(cat knit-version/version)"

  export GOPATH="${cwd}/go"
  pushd "${GOPATH}/src/github.com/pivotal-cf/knit" > /dev/null
    for OS in darwin linux; do
      CGO_ENABLED=0 \
      GOOS=${OS}  \
      GOARCH=amd64 \
      go build -ldflags "-X main.buildVersion=${version}" -o "${cwd}/binaries/knit-${OS}" main.go
    done
  popd > /dev/null
}

main "${PWD}"
