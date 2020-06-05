#!/bin/bash
set -euxo pipefail

# Get the current journald cursor.
export JOURNALD_CURSOR=$(sudo journalctl --quiet -n 1 --show-cursor | tail -n 1 | grep -oP 's\=.*$')

# Add a function to preserve the system journal if something goes wrong.
preserve_journal() {
  sudo journalctl --after-cursor=${JOURNALD_CURSOR} > systemd-journald.log
  exit 1
}
trap "preserve_journal" ERR

# Get OS details.
source /etc/os-release

# Get the latest master artifacts from osbuild-composer.
MOCK_REPO_BASE_URL="http://osbuild-composer-repos.s3-website.us-east-2.amazonaws.com"
CI_ARTIFACTS=osbuild/osbuild-composer/master/c866606

# Set up a dnf repository for a previously built known working package of
# osbuild and osbuild-composer.
sudo tee /etc/yum.repos.d/osbuild-mock.repo > /dev/null << EOF
[osbuild-mock]
name=osbuild mock S3 repo
baseurl=${MOCK_REPO_BASE_URL}/${CI_ARTIFACTS}/${ID}${VERSION_ID//./}
enabled=1
gpgcheck=0
# Default dnf repo priority is 99. Lower number means higher priority.
priority=5
EOF

# Verify that the repository we added is working properly.
sudo dnf list all | grep osbuild-mock

# Create temporary directories for Ansible.
sudo mkdir -vp /opt/ansible_{local,remote}
sudo chmod -R 777 /opt/ansible_{local,remote}

# Run deployment.
echo -e "[test_instances]\nlocalhost ansible_connection=local" > hosts.ini
ansible-playbook -i hosts.ini ${EXTRA_VARS:-} playbook.yml

# Mount a ramdisk on /run/osbuild to speed up testing.
sudo mkdir -p /run/osbuild
sudo mount -t tmpfs tmpfs /run/osbuild

# Once everything is deployed, add a blueprint and build it just to ensure
# everything is working.
ansible-playbook -i hosts.ini schutzbot/composer-smoke-test.yml

# Preserve the system journal.
sudo journalctl --after-cursor=${JOURNALD_CURSOR} > systemd-journald.log