#!/bin/bash
set -euxo pipefail

export JUNIT_OUTPUT_DIR=junit/

dnf -y install ansible python3-junit_xml

# Run a deployment
echo -e "[test_instances]\nlocalhost ansible_connection=local" > hosts.ini
ansible-playbook -i hosts.ini playbook.yml
