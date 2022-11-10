#!/bin/bash

set -euo pipefail

gpm_kubectl_install() {
  sudo curl -s -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl
  sudo chmod +x /usr/local/bin/kubectl
  kubectl completion bash | sudo tee -a /etc/bash_completion.d/kubectl > /dev/null
  kubectl version --client -o json
}
