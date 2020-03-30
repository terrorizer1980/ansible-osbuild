#!/bin/bash
set -euxo pipefail

env | sort
echo $WORKSPACE

export JUNIT_OUTPUT_DIR=junit/

sudo dnf -y install ansible python3-junit_xml

# Run a deployment
echo -e "[test_instances]\nlocalhost ansible_connection=local" > hosts.ini
ansible-playbook -i hosts.ini playbook.yml

# Get the integration test logs.
cp /tmp/composer_tests.log.xz $WORKSPACE
