#!/usr/bin/env bash
set -e
# Provisions an OpenLava cluster in OpenStack
# The script assumes that env vars for authentication with OpenStack are present.

## Customise this ##
export TF_VAR_name="user_XX" # substitute XX with your progressive user ID
export TF_VAR_DEPLOYMENT_KEY_PATH="path_to_your_private_key"
bastion_ip=bastion_ip

# Launch provisioning of the infrastructure
cd terraform || exit
terraform apply
cd ..

# Extract master ip from
master_ip=$(terraform output -state='terraform/terraform.tfstate' MASTER_IP)

# Extract volumes mapping from TF state file
./volume_parser.py 'terraform/terraform.tfstate' 'ostack_volumes_mapping.json'

# Check if ssh-agent is running
eval "$(ssh-agent -s)" &> /dev/null
ssh-add $TF_VAR_DEPLOYMENT_KEY_PATH &> /dev/null

# Launch Ansible
cd ansible || exit
TF_STATE='../terraform/terraform.tfstate' ansible-playbook -i /usr/local/bin/terraform-inventory --extra-vars "bastion_ip=$bastion_ip" -u centos deployment.yml

# Kill local ssh-agent
eval "$(ssh-agent -k)"

echo "Your master IP is $master_ip"
