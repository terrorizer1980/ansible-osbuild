#!/bin/bash
set -euxo pipefail

# Ensure we have the right packages installed.
sudo dnf -y install ansible

# Run deployment.
echo -e "[test_instances]\nlocalhost ansible_connection=local" > hosts.ini
ansible-playbook -i hosts.ini ${EXTRA_VARS:-} playbook.yml