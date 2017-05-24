# Create a keypair
resource "openstack_compute_keypair_v2" "demo_keypair" {
  name = "${var.name}_keypair"
  public_key = "${file("${var.pubkey}")}"
}

# Create a network
resource "openstack_networking_network_v2" "demo_network" {
  name = "${var.name}_network"
  admin_state_up = "true"
}

# Create a subnet
resource "openstack_networking_subnet_v2" "demo_subnet" {
  name = "${var.name}_subnet"
  network_id = "${openstack_networking_network_v2.demo_network.id}"
  cidr = "10.0.0.0/24"
  ip_version = 4
}

# Create a web server
resource "openstack_compute_instance_v2" "basic" {
  name            = "${var.name}_machine"
  image_id        = "7b5fea5e-7a75-46de-a1c4-5e7fae18eb85"
  flavor_name     = "s1.tiny"
  key_pair        = "${openstack_compute_keypair_v2.demo_keypair.name}"
  security_groups = ["base_vms_basic_sec"]

  network {
    name = "${openstack_networking_network_v2.demo_network.name}"
  }
}
