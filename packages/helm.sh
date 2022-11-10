#!/bin/bash

set -euo pipefail

gpm_helm_install() {
  curl -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
  helm completion bash | sudo tee -a /etc/bash_completion.d/helm > /dev/null
  helm version
}
