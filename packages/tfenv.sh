#!/bin/bash

set -euo pipefail

gpm_tfenv_install() {
  rm -Rf "${HOME}/.tfenv"
  sudo rm -f /usr/local/bin/terraform
  sudo rm -f /usr/local/bin/tfenv
  git clone --depth=1 https://github.com/tfutils/tfenv.git "${HOME}/.tfenv"
  sudo ln -s "${HOME}/.tfenv/bin/terraform" /usr/local/bin/terraform
  sudo ln -s "${HOME}/.tfenv/bin/tfenv" /usr/local/bin/tfenv
}
