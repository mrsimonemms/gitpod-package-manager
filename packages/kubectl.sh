#!/bin/bash

set -euo pipefail

gpm_kubectl_install() {
  version="${1}"

  if [ "${version}" = "latest" ]; then
    sudo curl -sSfL "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl
  else
    sudo curl -sSfL "https://dl.k8s.io/release/v${version}/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl
  fi
  sudo chmod +x /usr/local/bin/kubectl
  kubectl completion bash | sudo tee -a /etc/bash_completion.d/kubectl > /dev/null
  kubectl version --client -o json
}
