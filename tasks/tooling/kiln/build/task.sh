#!/bin/bash -eu

: "${GITHUB_TOKEN:?}"
[[ -d goreleaser ]] || (>&2 echo "goreleaser directory is required" && exit 1)
[[ -f kiln-version/version ]] || (>&2 echo "kiln-version/version file is required" && exit 1)

function main() {
  local cwd version
  cwd="${1}"
  version="$(cat "${cwd}/kiln-version/version")"

  pushd "${cwd}/goreleaser" > /dev/null
    go get ./...
  popd > /dev/null

  pushd "${cwd}/kiln" > /dev/null
    git config --global user.name "Release Engineering Bot"
    git config --global user.email "cf-release-engineering@pivotal.io"
    git tag -f "$version" HEAD
    goreleaser release
  popd > /dev/null
}

main "${PWD}"
