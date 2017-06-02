# Variables for the OpenLava cluster
variable "availability_zone" {
  type        = "string"
  description = "The availability zone to be used in the deployment"

  default = ""
}

variable "network_name" {
  type        = "string"
  description = "The ID of the network where VM should be connected"

  default = "base_vms_network"
}

variable "subnet_network_block" {
  type = "string"
  description = "The subnet of the network where the VMs are connected"

  default = "10.100.0.0/16"
}

variable "floating_pool" {
  type        = "string"
  description = "The name of the floating IPs pool"

  default = "ext-net"
}

variable "master_image_id" {
  type        = "string"
  description = "The pre-baked image for the master node"

  default = "7b5fea5e-7a75-46de-a1c4-5e7fae18eb85"
}

variable "node_image_id" {
  type        = "string"
  description = "The pre-baked image for the compute node"

  default = "7b5fea5e-7a75-46de-a1c4-5e7fae18eb85"
}

variable "nfs_image_id" {
  type        = "string"
  description = "The pre-baked image for the NFS server"

  default = "7b5fea5e-7a75-46de-a1c4-5e7fae18eb85"
}

variable "master_flavor" {
  type        = "string"
  description = "The flavor to be used for the master node"

  default = "s1.tiny"
}

variable "node_flavor" {
  type        = "string"
  description = "The flavor to be used for the compute nodes"

  default = "s1.tiny"
}

variable "nfs_flavor" {
  type        = "string"
  description = "The flavor to be used for the NFS server"

  default = "s1.tiny"
}

variable "homes_size" {
  type        = "string"
  description = "The size of the volume storing the user homes"

  default = 10
}

variable "data_volume_size" {
  type        = "string"
  description = "The size of the volume storing the data"

  default = 10
}

variable "nodes" {
  type        = "string"
  description = "Number of compute cluster to be deployed"

  default = 1
}

variable "name" {
  type        = "string"
  description = "Name of the OpenLava instance"

  default = "mg-openlava"
}

variable "DEPLOYMENT_KEY_PATH" {
  type        = "string"
  description = "The path to the full SSH KEY used to deploy & provision the VM"
}
