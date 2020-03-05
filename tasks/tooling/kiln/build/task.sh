#!/bin/bash -eu

function main() {
  local cwd
  cwd="${1}"

  local version
  version="$(cat kiln-version/version)"

  export GOPATH="${cwd}/go"
  pushd "${GOPATH}/src/github.com/pivotal-cf/kiln" > /dev/null
    source .envrc
    for OS in darwin linux windows; do
      local name
      name="kiln-${OS}"

      if [[ "${OS}" == "windows" ]]; then
        name="${name}.exe"
      fi

      CGO_ENABLED=0 \
      GOOS=${OS} \
      GOARCH=amd64 \
        go build \
          -ldflags "-X main.version=${version}" \
          -o "${cwd}/binaries/${name}" \
          main.go
    done
  popd > /dev/null
}

main "${PWD}"
