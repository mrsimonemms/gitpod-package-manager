#!/bin/bash

set -euo pipefail

gpm_faas-cli_install() {
  version="${1}"

  if [ "${version}" = "latest" ]; then
    curl -sSfL https://cli.openfaas.com | sudo sh
  else
    OWNER="openfaas"
    REPO="faas-cli"
    suffix=""
    targetFile="/usr/local/bin/${REPO}"
    aliasTargetFile="/usr/local/bin/faas"

    url="https://github.com/${OWNER}/${REPO}/releases/download/${version}/${REPO}$suffix"
    echo "Downloading package $url as $targetFile"

    sudo rm -f "${targetFile}"
    sudo rm -f "${aliasTargetFile}"
    sudo curl -sSLf "${url}" --output "${targetFile}"
    sudo chmod +x "${targetFile}"
    sudo ln -s "${targetFile}" "${aliasTargetFile}"
  fi

  faas-cli version
}
