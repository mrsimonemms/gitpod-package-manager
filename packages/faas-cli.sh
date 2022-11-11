#!/bin/bash

set -euo pipefail

gpm_faas-cli_install() {
  curl -sSL https://cli.openfaas.com | sudo sh
  faas-cli version
}
