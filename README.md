# ansible-osbuild

This repository contains a set of Ansible playbooks and roles for deploying
osbuild and osbuild-composer on Fedora 31+, RHEL 8.2+, and CentOS 8.2+.

## Deploying personal test infrastructure

You can use the scripts and playbooks here to deploy your own testing
infrastructure on EC2.

### Prepare your AWS CLI

Start by [installing the AWS CLI version 2]:

```text
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

After the installation, run the [configuration step]:

```text
aws configure --profile personal
```

Verify that you can authenticate with AWS:

```text
aws s3 ls
aws sts get-caller-identity
```

### Edit the EC2 variables

All of the deployment variables are in `ec2/ec2_vars.yml`. Adjust any
variables to match your requirements and comment out any instances you do not
want to deploy.

### Run the deployment

Run the script:

```text
./deploy_ec2.sh
```

There are two phases of the deployment:

1. Creating infrastructure on EC2 to run the osbuild/osbuild-composer services
2. Deploying the osbuild/osbuild-composer services

The first step should take 2-3 minutes. The second step takes a little longer
since all of the RPMs must be built and deployed.

When it's all finished, your deployed instances should be in
``/tmp/osbuild.personal.USERNAME/hosts.ini`` Use the IP address, username, and
private key file shown there to log in.

[installing the AWS CLI version 2]: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
[configuration step]: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html
