#!/bin/bash
set -euxo pipefail

BASEDIR=/tmp/ansible-osbuild

# Install some basic packages.
dnf -y install git python3 python3-pip python3-pip-wheel
pip3 install ansible

# Clone the latest testing code
git clone https://github.com/osbuild/ansible-osbuild $BASEDIR

# Write out a basic hosts file.
cat << EOF > ${BASEDIR}/hosts.ini
[deployer]
localhost ansible_connection=localhost ansible_python_interpreter=/usr/bin/python3
EOF

# Run the playbook
export ANSIBLE_CONFIG=${BASEDIR}/ansible.cfg
ansible-playbook -i ${$BASEDIR}/hosts.ini ${$BASEDIR}/playbook.yml
