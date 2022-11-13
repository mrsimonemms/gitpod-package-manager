#!/bin/bash

set -euo pipefail

gpm_yq_install() {
  version="${1}"
  url="https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64"

  if [ "${version}" != "latest" ]; then
    url="https://github.com/mikefarah/yq/releases/download/v${version}/yq_linux_amd64"
  fi

  sudo wget "${url}" -O /usr/bin/yq
  sudo chmod +x /usr/bin/yq
  yq --version
}
