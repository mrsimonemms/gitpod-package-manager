# Gitpod Package Manager

A package manager for Gitpod workspaces

## Why?

I was getting fed up having to create `.gitpod.yml` or `.gitpod.Dockerfile` files with
loads of custom scripts to install packages I used regularly. This became really painful
when third-party packages would ~break~ update their installation scripts and I'd have
to change it in every project I use.

So, I thought I'd make something that I can use centrally.

## Getting started

In your `.gitpod.yml` file, you will need to add an `init` command to your `tasks` array.
Use the `before` rather than `init` as prebuilds only save the workspace directory.

```yaml
tasks:
  - before: |
      curl -sfL gpm.simonemms.com | bash

      gpm install kubectl helm
```

This is built with forking in mind. If you want to maintain your own packages, simply
configure the `GPM_REPO_URL` envvar.

```yaml
tasks:
  - env:
      GPM_REPO_URL: https://raw.githubusercontent.com/<owner>/<repo>/<branch>
    before: |
      curl -sfL ${GPM_REPO_URL}/gpm.sh | bash

      gpm install kubectl helm my-custom-package
```

## Contributing

PRs welcome.

### Function template

> In these examples, `<pkg>` is the package name. It should be the name of the binary that's
> installed (eg, `kubectl`, `helm` etc)

All functions should follow these standards:

- Open-source projects only - you can maintain your own proprietary packages in a fork
- It must expose a function called `gpm_<pkg>_install`
- It must install the latest version of the binary (a future iteration will allow specific versions to be installed)
- Filename should be `<pkg>.sh`
- It should install only one binary
- The binary should be executed with a `--version` command or similar to check that it's installed correctly
- Ensure your script does not make any changes to the cloned workspace

```shell
#!/bin/bash

set -euo pipefail

gpm_<pkg>_install() {
  echo "Install <pkg>"
}
```
