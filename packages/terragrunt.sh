#!/bin/bash

set -euo pipefail

gpm_terragrunt_install() {
  version="${1}"

  if [ "${version}" = "latest" ]; then
    # Get the latest version ID from GitHub
    version="$(curl -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | jq -r '.tag_name'  | sed 's/v//')"
  fi

  rm -f /tmp/terragrunt
  curl -sSfL "https://github.com/gruntwork-io/terragrunt/releases/download/v${version}/terragrunt_linux_amd64" -o /tmp/terragrunt
  sudo install -o root -g root -m 0755 /tmp/terragrunt /usr/local/bin/terragrunt
  terragrunt --version
}
