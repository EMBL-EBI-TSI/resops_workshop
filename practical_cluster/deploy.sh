#!/usr/bin/env bash
set -e
# Provisions an OpenLava cluster in OpenStack
# The script assumes that env vars for authentication with OpenStack are present.

## Customise this ##

## TF_VAR_* variables are picked up by Terraform to populate its own variables.
## TF_VAR_name, for example, will be used to populate the variable "name". In
## this case, we're setting a separate name for each of you to avoid clashed in
## the deployed infrastructure.
export TF_VAR_name="user_XX" # substitute XX with your progressive user ID

## As part of the deployment process, Terraform will upload you private key
## to OpenStack and inject it into the VMs to allow you (and Ansible) to access
## them. We'll cover how this works in a second.
## WARNING: do not use "~" in the path here, but use the *absolute* path to the key.
export TF_VAR_DEPLOYMENT_KEY_PATH="path_to_your_private_key"

## To reduce our footprint in terms of required public ips, this deployment
## uses a bastion host (the same one you configured for SSH earlier on) to access
## the VMs. Ansible needs to do the same, hence the need to save it in a variable
## that is then provided as an input to Ansible.
bastion_ip=bastion_ip # substitute bastion_ip with the IP of the bastion

## Here we go, all needed variables are set, and we're ready to deploy our
## infrastructure running Terraform.
cd terraform || exit
terraform apply
cd ..

## To connect to your new OpenLava cluster you need to know the IP address of
## the master node. Terraform allows to extract bits of information from it state
## file as outputs. This needs to be defined in the code itself (have a look
## at terraform/openlava_instances.tf) and can later on be extracted via the
## terraform output command. In this case, we're saving the IP only to display
## it on screen later, but in a full stack network deployment the Master node may
## act also as a bastion.
master_ip=$(terraform output -state='terraform/terraform.tfstate' MASTER_IP)

# Extract volumes mapping from TF state file
## OpenStack used to be very impolite with device mappings. Terraform allows you
## to request a specific device (/dev/vd*) where a given volume should be mounted,
## but there's no guarantee OpenStack will comply. An easy workaround is to not
## request a particular device, but simply read the assigned ones in the Terraform
## state file. Volume_parser.py is an auxiliary script that does just this and
## spits out the result in a json file that is then used by Ansible to know what
## to mount where.
./volume_parser.py 'terraform/terraform.tfstate' 'ostack_volumes_mapping.json'

## SSH Agent is a small deamon that runs in the background and can be used to
## temporarily cache the SSH private keys to be used when you connect to a host
## via SSH. This is particularly handy when the SSH key is protected by a passphrase
## and you don't want to type it every time. It also allows to use advanced
## features as SSH Agent Forwarding that might be helpful in some occasions. In
## the two lines below case, we're spawning a new ssh-agent and adding your private
## key to it.
eval "$(ssh-agent -s)" &> /dev/null
ssh-add $TF_VAR_DEPLOYMENT_KEY_PATH &> /dev/null

## OK, key is loaded, so we're ready to go.
## But, hold on a second! How can Ansible know where the VMs are? We need to convert
## the Terraform state file into an Ansible inventory to make it work. While Ansible
## can autonomously query OpenStack to know which VMs are running, this might take
## a while and give unexpected results if somebody else is deploying on the same
## tenancy. For these reasons, in this deployment we're using terraform-inventory,
## a small utility that converts the state file into an inventory. Ansible is
## invoking terraform-inventory on its own (-i /usr/local/bin/terraform-inventory),
## as it can accept as an inventory a script that returns a properly formatted inventory.
## TF_STATE tells terraform-inventory where the state file is.
cd ansible || exit
TF_STATE='../terraform/terraform.tfstate' ansible-playbook -i /usr/local/bin/terraform-inventory --extra-vars "bastion_ip=$bastion_ip" -u centos deployment.yml

## The provisioning is hopefully complete now. We don't need the ssh-agent anymore,
## and we can kill it.
eval "$(ssh-agent -k)"

## We now show on screen what is the IP of the master node of the newly deployed
## cluster.
echo "Your master IP is $master_ip"

## Done!
