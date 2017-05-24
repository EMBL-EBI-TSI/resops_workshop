# Variables for the OpenLava cluster
variable "availability_zone" {
  type        = "string"
  description = "The availability zone to be used in the deployment"

  default = ""
}

variable "subnet_network_block" {
  type        = "string"
  description = "Network block to be used for the openlava subnet"

  default = "10.22.100.0/24"
}

variable "floating_pool" {
  type        = "string"
  description = "The name of the floating IPs pool"

  default = "ext-net"
}

variable "external_net_uuid" {
  type        = "string"
  description = "The UUID of the external network"

  default = "2d771d9c-f279-498f-8b8a-f5c6d83da6e8"
}

variable "master_image_id" {
  type        = "string"
  description = "The pre-baked image for the master node"

  default = "9c380406-068c-4eb9-9689-089ac2d49402"
}

variable "node_image_id" {
  type        = "string"
  description = "The pre-baked image for the compute node"

  default = "f4c6ac78-8960-4bbf-8215-d9329c992dd5"
}

variable "nfs_image_id" {
  type        = "string"
  description = "The pre-baked image for the NFS server"

  default = "8207bafe-01f9-4cf0-a028-3f4fcc8fa783"
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
