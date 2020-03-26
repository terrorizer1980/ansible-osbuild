#!/bin/bash
set -euxo pipefail

dnf -y install ansible python3-ansible-lint

# Rule 403: Package installs should not use latest
ansible-lint --force-color -x 403 playbook.yml 2>&1 | tee jenkins.log

# Run a deployment
echo -e "[test_instances]\nlocalhost ansible_connection=local" > hosts.ini
ansible-playbook -i hosts.ini playbook.yml
