#!/bin/bash
set -euo pipefail

# Get the current user.
CURRENT_USER=$(whoami)

# Create a temporary directory.
TEMPDIR="/tmp/osbuild.personal.${CURRENT_USER}"
mkdir -p $TEMPDIR

# Deploy the EC2 infrastructure.
ansible-playbook -i localhost, ec2/deploy_on_ec2.yml

# Deploy osbuild and osbuild-composer.
ansible-playbook -i ${TEMPDIR}/hosts.ini playbook.yml
