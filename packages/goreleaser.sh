#!/bin/bash

set -euo pipefail

gpm_goreleaser_install() {
  version="${1}"

  if [ "${version}" = "latest" ]; then
    # Get the latest version ID from GitHub
    version="$(curl -s https://api.github.com/repos/goreleaser/goreleaser/releases/latest | jq -r '.tag_name'  | sed 's/v//')"
  fi

  rm -f /tmp/goreleaser.deb
  curl -sSfL "https://github.com/goreleaser/goreleaser/releases/download/v${version}/goreleaser_${version}_amd64.deb" -o /tmp/goreleaser.deb
  sudo dpkg -i /tmp/goreleaser.deb
}
