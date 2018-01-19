resource "openstack_networking_network_v2" "openlava_network" {
  name           = "${var.name}_network"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "openlava_subnet" {
  name            = "${var.name}_subnetwork"
  network_id      = "${openstack_networking_network_v2.openlava_network.id}"
  cidr            = "${var.subnet_network_block}"
  enable_dhcp     = "True"
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

resource "openstack_networking_router_v2" "openlava_router" {
  region              = ""
  name                = "${var.name}_router"
  external_network_id = "${var.external_net_uuid}"
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  region    = ""
  router_id = "${openstack_networking_router_v2.openlava_router.id}"
  subnet_id = "${openstack_networking_subnet_v2.openlava_subnet.id}"
}

resource "openstack_networking_floatingip_v2" "openlava_floatip" {
  region = ""
  pool   = "${var.floating_pool}"
}
