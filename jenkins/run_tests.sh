#!/bin/bash
set -euxo pipefail

# Ensure we have the right packages installed.
sudo dnf -y install ansible

# Create temporary directories for Ansible.
sudo mkdir -vp /opt/ansible_{local,remote}
sudo chmod -R 777 /opt/ansible_{local,remote}

# Run deployment.
echo -e "[test_instances]\nlocalhost ansible_connection=local" > hosts.ini
ansible-playbook -i hosts.ini ${EXTRA_VARS:-} playbook.yml