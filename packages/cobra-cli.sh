#!/bin/bash

set -euo pipefail

gpm_cobra-cli_install() {
  version="${1}"

  go install "github.com/spf13/cobra-cli@${version}"

  cobra-cli completion bash | sudo tee -a /etc/bash_completion.d/cobra-cli > /dev/null
  cobra-cli help
}
