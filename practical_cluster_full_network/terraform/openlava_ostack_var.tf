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

  default = "ext-net-36"
}

variable "external_net_uuid" {
  type        = "string"
  description = "The UUID of the external network"

  default = "e25c3173-bb5c-4bbc-83a7-f0551099c8cd"
}

variable "master_image_id" {
  type        = "string"
  description = "The pre-baked image for the master node"

  default = "783f08f3-8acc-4cb7-9d06-723046ccf89c"
}

variable "node_image_id" {
  type        = "string"
  description = "The pre-baked image for the compute node"

  default = "783f08f3-8acc-4cb7-9d06-723046ccf89c"
}

variable "nfs_image_id" {
  type        = "string"
  description = "The pre-baked image for the NFS server"

  default = "783f08f3-8acc-4cb7-9d06-723046ccf89c"
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
