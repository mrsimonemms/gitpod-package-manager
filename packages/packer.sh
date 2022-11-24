#!/bin/bash

set -euo pipefail

gpm_packer_install() {
  version="${1}"

  if [ "${version}" = "latest" ]; then
    # Get the latest version ID from GitHub
    version="$(curl -s https://api.github.com/repos/hashicorp/packer/releases/latest | jq -r '.tag_name'  | sed 's/v//')"
  fi

  rm -Rf /tmp/packer*
  curl -sSfL "https://releases.hashicorp.com/packer/${version}/packer_${version}_linux_amd64.zip" -o /tmp/packer.zip
  unzip /tmp/packer.zip -d /tmp
  sudo install -o root -g root -m 0755 /tmp/packer /usr/local/bin/packer
  packer version
}
