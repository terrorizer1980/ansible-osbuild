#!/bin/bash
# This script attempts to boot an instance in EC2 using different
# instance types and subnets.

{% for instance_type in instance_types[instance_data.arch] %}
  {% for subnet_id in ec2_subnets.results | map(attribute='subnet.id') %}

aws ec2 run-instances \
    --associate-public-ip-address \
    --block-device-mappings DeviceName=/dev/sda1,Ebs=\{DeleteOnTermination=true,VolumeSize=50,VolumeType=gp2,Encrypted=false\} \
{% if instance_type.startswith('t3') %}
    --credit-specification CpuCredits=standard \
{% endif %}
    --image-id {{ (latest_ami.images | sort(attribute='creation_date') | last)['image_id'] }} \
{% if use_spot_instances %}
    --instance-market-options MarketType=spot,SpotOptions=\{MaxPrice=1.00,SpotInstanceType=one-time,InstanceInterruptionBehavior=terminate\} \
{% endif %}
    --instance-type {{ instance_type }} \
    --key-name osbuild.personal.{{ ansible_user_id }} \
    --security-group-ids {{ ec2_security_group.group_id }} \
    --subnet-id {{ subnet_id }} \
    --tag-specifications ResourceType=instance,Tags=[\{Key=Name,Value='osbuild.personal.{{ ansible_user_id }}.{{ instance_data.name }}'\}] \
    --user-data "file://{{ tempdir.path }}/userdata"

return_code=$?
if [[ $return_code == 0 ]]; then
  exit 0
fi

  {% endfor %}
{% endfor %}

# If we had no successful boots, we should exit with a failure.
exit 1
