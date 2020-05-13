#!/bin/bash
set -euxo pipefail

# Get OS information.
source /etc/os-release

# Create temporary directories for Ansible.
sudo mkdir -vp /opt/ansible_{local,remote}
sudo chmod -R 777 /opt/ansible_{local,remote}

# Set up the dnf repository for the packages built in mock.
if [[ ${DEPLOY_REPO:-no} == 'yes' ]]; then
sudo tee "/etc/yum.repos.d/osbuild-mock.repo" <<EOF
[osbuild-mock]
name=OSBuild mock RPM builds
baseurl=${S3_WEB_URL}/${MOCK_VERSION_ID}/${ID}${VERSION_ID/./}/
enabled=1
gpgcheck=0
# Make this repo *very* high priority to ensure we install osbuild-related
# packages only from this repo. This affects CI only. Customers won't ever
# deal with this problem.
priority=1
EOF
fi

# Run deployment.
echo -e "[test_instances]\nlocalhost ansible_connection=local" > hosts.ini
ansible-playbook -i hosts.ini ${EXTRA_VARS:-} playbook.yml

# Verify that we installed the correct packages from the repository if we
# installed from a yum repository.
if [[ ${DEPLOY_REPO:-no} == 'yes' ]]; then
    PKG_COUNT=$(rpm -qa | grep ${EXPECTED_RPM_VERSION} | wc -l)
    if [[ $PKG_COUNT != "7" ]]; then
        echo "We expected to see seven packages installed, but we only saw ${PKG_COUNT}."
    fi
fi