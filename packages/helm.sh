#!/bin/bash

set -euo pipefail

gpm_helm_install() {
  version="${1}"
  DESIRED_VERSION=""
  if [ "${version}" != "latest" ]; then
    DESIRED_VERSION="v${version}"
  fi

  curl -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | DESIRED_VERSION="${DESIRED_VERSION}" bash
  helm completion bash | sudo tee -a /etc/bash_completion.d/helm > /dev/null
  helm version
}
