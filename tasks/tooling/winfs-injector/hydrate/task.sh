#!/bin/bash -eu

function main() {
  local tile_file_name
  tile_file_name="$(basename "$(ls ./wrt-unhydrated/*.pivotal)")"

  local input_tile
  input_tile="./wrt-unhydrated/${tile_file_name}"

  local output_tile
  output_tile="./wrt/${tile_file_name}"

  chmod 0700 winfs-injector-release/winfs-injector-linux

  winfs-injector-release/winfs-injector-linux \
      --input-tile "${input_tile}" \
      --output-tile "${output_tile}"
}

main
