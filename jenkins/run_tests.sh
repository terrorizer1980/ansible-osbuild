#!/bin/bash
set -euxo pipefail

# Run ansible-lint
dnf -y install python3-ansible-lint
ansible-lint --version

# Rule 403: Package installs should not use latest
ansible-lint --force-color -x 403 playbook.yml 2>&1 | tee jenkins.log
