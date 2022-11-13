#!/bin/bash

################################################################################
# ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜ #
# ▌ Copyright © 2022 Simon Emms <simon@simonemms.com>                        ▐ #
# ▌                                                                          ▐ #
# ▌ Licensed under the Apache License, Version 2.0 (the "License");          ▐ #
# ▌ you may not use this file except in compliance with the License.         ▐ #
# ▌ You may obtain a copy of the License at                                  ▐ #
# ▌                                                                          ▐ #
# ▌     http://www.apache.org/licenses/LICENSE-2.0                           ▐ #
# ▌                                                                          ▐ #
# ▌ Unless required by applicable law or agreed to in writing, software      ▐ #
# ▌ distributed under the License is distributed on an "AS IS" BASIS,        ▐ #
# ▌ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. ▐ #
# ▌ See the License for the specific language governing permissions and      ▐ #
# ▌ limitations under the License.                                           ▐ #
# ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟ #
#                                                                              #
# ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜ #
# ▌ Source code: https://github.com/MrSimonEmms/gitpod-package-manager       ▐ #
# ▌ Install URL: https://gpm.simonemms.com                                   ▐ #
# ▌ Me:          https://www.simonemms.com                                   ▐ #
# ▌ Gitpod:      https://www.gitpod.io                                       ▐ #
# ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟ #
################################################################################

set -euo pipefail

#################
# ▛▀▀▀▀▀▀▀▀▀▀▀▜ #
# ▌ Variables ▐ #
# ▙▄▄▄▄▄▄▄▄▄▄▄▟ #
#################

USE_REMOTE_REPO=0
if [ -z "${BASH_SOURCE:-}" ]; then
  CMD="${CMD:-init}"
  USE_REMOTE_REPO=1
else
  CMD="${1:-}"
fi

GPM_REPO_URL="${GPM_REPO_URL:-https://raw.githubusercontent.com/MrSimonEmms/gitpod-package-manager/main}"
TARGET_INSTALL_PATH="/usr/local/bin"

#########################
# ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜ #
# ▌ Private Functions ▐ #
# ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟ #
#########################

# Generate help text for commands
_help() {
  text="${1}"

  if [[ "${*}" =~ (--help|-h)(\b|$) ]]; then
    echo "${text}"
    exit
  fi
}

########################
# ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜ #
# ▌ Public Functions ▐ #
# ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟ #
########################

init() {
  help=$(cat << EOF
Installs Gitpod Package Manager to your Gitpod workspace

Packages are pulled from the GPM_REPO_URL envvar, currently set to:
  ${GPM_REPO_URL}

Usage:
  init

Flags:
  -h, --help       Display help
EOF
)
  _help "${help}" "${@}"

  sudo curl -sfL "${GPM_REPO_URL}/gpm.sh" -o "${TARGET_INSTALL_PATH}/gpm"
  sudo chmod +x "${TARGET_INSTALL_PATH}/gpm"

  cat << EOF
Gitpod Package Manager installed to ${TARGET_INSTALL_PATH}/gpm

To install packages, run gpm install <package1> <package2>...
EOF
}

install() {
  help=$(cat << EOF
Installs packages to your Gitpod workspace

Packages are pulled from the GPM_REPO_URL envvar, currently set to:
  ${GPM_REPO_URL}

Usage:
  install <package1> <package2>...

Flags:
  -h, --help       Display help
EOF
)
  _help "${help}" "${@}"

  if [ -z "${*}" ]; then
    echo "No packages specified"
    exit 1
  fi

  for item in "${@}"; do
    IFS='@' read -r -a array <<< "${item}"
    pkg="${array[0]}"
    pkg_version="${array[1]:-latest}"

    pkg_path="/tmp/gpm_${pkg}.sh"
    sudo rm -f "${pkg_path}"

    if [ -f "./packages/${pkg}.sh" ]; then
      cp "./packages/${pkg}.sh" "${pkg_path}"
    else
      sudo curl -fsL "${GPM_REPO_URL}/packages/${pkg}.sh" -o "${pkg_path}" || (echo "Unknown package: ${pkg}" && exit 1)
    fi

    # shellcheck source=/dev/null
    source "${pkg_path}"

    echo "Installing package: ${pkg}@${pkg_version}"
    "gpm_${pkg}_install" "${pkg_version}" > >(trap "" INT TERM; sed 's/^/[gpm]: /')
    echo "Package installed: ${pkg}@${pkg_version}"
  done
}

#######################
# ▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▜ #
# ▌ Public Commands ▐ #
# ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▟ #
#######################

case "${CMD}" in
  init )
    if [ "${USE_REMOTE_REPO}" -eq 0 ]; then
      shift 1
    fi

    init "${@}"
    ;;
  install )
    if [ "${USE_REMOTE_REPO}" -eq 0 ]; then
      shift 1
    fi

    install "${@}"
    ;;
  * )
    cat << EOF
A package manager for Gitpod workspaces

Usage:
  gpm [command]

Available commands:
  init              Installs Gitpod Package Manager to your Gitpod workspace
  install           Installs packages to your Gitpod workspace

Flags:
  -h, --help        Display help
EOF
    ;;
esac
