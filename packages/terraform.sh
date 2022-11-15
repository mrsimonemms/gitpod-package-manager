#!/bin/bash

set -euo pipefail

gpm_terraform_install() {
  version="${1}"

  if [ "${version}" != "latest" ]; then
    echo "Terraform does not support versions other than 'latest'"
    exit 1
  fi

  wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
  sudo apt update
  sudo apt install -y terraform
  terraform version
  terraform -install-autocomplete
}
