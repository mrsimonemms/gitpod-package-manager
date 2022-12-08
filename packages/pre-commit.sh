#!/bin/bash

set -euo pipefail

gpm_pre-commit_install() {
  version="${1}"

  if [ "${version}" = "latest" ]; then
    # Get the latest version ID from GitHub
    version="$(curl -s https://api.github.com/repos/pre-commit/pre-commit/releases/latest | jq -r '.tag_name'  | sed 's/v//')"
  fi

  rm -f /tmp/pre-commit.pyz
  curl -sSfL "https://github.com/pre-commit/pre-commit/releases/download/v${version}/pre-commit-${version}.pyz" -o /tmp/pre-commit.pyz
  sudo install -o root -g root -m 0755 /tmp/pre-commit.pyz /usr/local/bin/pre-commit
  pre-commit --version
}
