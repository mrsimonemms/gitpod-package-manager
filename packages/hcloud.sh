#!/bin/bash

set -euo pipefail

gpm_hcloud_install() {
  version="${1}"

  if [ "${version}" = "latest" ]; then
    # Get the latest version ID from GitHub
    version="$(curl -s https://api.github.com/repos/hetznercloud/cli/releases/latest | jq -r '.tag_name'  | sed 's/v//')"
  fi

  rm -f /tmp/hcloud-linux-amd64.tar.gz
  curl -sSfL "https://github.com/hetznercloud/cli/releases/download/v${version}/hcloud-linux-amd64.tar.gz" -o /tmp/hcloud-linux-amd64.tar.gz
  tar -zxf /tmp/hcloud-linux-amd64.tar.gz -C /tmp
  sudo install -o root -g root -m 0755 /tmp/hcloud /usr/local/bin/hcloud
  hcloud version
}
