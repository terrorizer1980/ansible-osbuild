#!/bin/bash
set -euxo pipefail

# Ensure we have the right packages installed.
sudo dnf -y install ansible

# Check to see if we are supposed to run integration tests.
if [[ ${RUN_INTEGRATION_TESTS:-0} == 1 ]]; then
  EXTRA_VARS="-e 'run_integration_tests=yes'"
fi

# Set up a hosts file for Ansible.
echo -e "[test_instances]\nlocalhost ansible_connection=local" > hosts.ini
ansible-playbook -i hosts.ini ${EXTRA_VARS:-} playbook.yml

# Run testing playbook
ansible-playbook -i hosts.ini jenkins/test.yml