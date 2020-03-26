#!/bin/bash
set -euxo pipefail

# Run ansible-lint
dnf -y install python3-ansible-lint
# ansible-lint playbook.yml
