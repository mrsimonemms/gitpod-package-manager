#!/bin/bash

set -euo pipefail

gpm_tfenv_install() {
  version="${1}"
  rm -Rf "${HOME}/.tfenv"
  sudo rm -f /usr/local/bin/terraform
  sudo rm -f /usr/local/bin/tfenv
  git clone https://github.com/tfutils/tfenv.git "${HOME}/.tfenv"
  if [ "${version}" != "latest" ]; then
    echo "Checking out version"
    cd "${HOME}/.tfenv"
    git checkout "v${version}"
    cd -
  fi
  sudo ln -s "${HOME}/.tfenv/bin/terraform" /usr/local/bin/terraform
  sudo ln -s "${HOME}/.tfenv/bin/tfenv" /usr/local/bin/tfenv
}
