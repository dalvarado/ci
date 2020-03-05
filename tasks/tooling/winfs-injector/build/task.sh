#!/bin/bash -eu

function main() {
  local cwd
  cwd="${1}"

  local version
  version="$(cat winfs-injector-version/version)"

  export GOPATH="${cwd}/gopath"
  pushd "${GOPATH}/src/github.com/pivotal-cf/winfs-injector" > /dev/null
    for OS in darwin linux windows; do
      local name
      name="winfs-injector-${OS}"

      if [[ "${OS}" == "windows" ]]; then
        name="${name}.exe"
      fi

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
