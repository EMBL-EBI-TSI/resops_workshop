resource "openstack_networking_secgroup_v2" "openlava_basic_sec" {
  name        = "${var.name}_basic_sec"
  description = "Allows SSH & ICMP"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.openlava_basic_sec.id}"
}

resource "openstack_networking_secgroup_rule_v2" "icmp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.openlava_basic_sec.id}"
}

resource "openstack_networking_secgroup_v2" "openlava_cluster" {
  name                 = "${var.name}_cluster"
  description          = "Allows OpenLava ports"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "openlava_cluster_tcp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1024
  port_range_max    = 65535
  remote_group_id   = "${openstack_networking_secgroup_v2.openlava_cluster.id}"
  security_group_id = "${openstack_networking_secgroup_v2.openlava_cluster.id}"
}

resource "openstack_networking_secgroup_rule_v2" "openlava_cluster_udp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 6322
  port_range_max    = 6322
  remote_group_id   = "${openstack_networking_secgroup_v2.openlava_cluster.id}"
  security_group_id = "${openstack_networking_secgroup_v2.openlava_cluster.id}"
}

resource "openstack_networking_secgroup_v2" "openlava_NFSv4" {
  name                 = "${var.name}_NFSv4"
  description          = "Allows NFSv4"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "openlava_NFSv4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 2049
  port_range_max    = 2049
  remote_ip_prefix  = "${var.subnet_network_block}"
  security_group_id = "${openstack_networking_secgroup_v2.openlava_NFSv4.id}"
}

resource "openstack_networking_secgroup_v2" "openlava_master_ports" {
  name                 = "${var.name}_HTTP"
  description          = "Allows access to Ganglia Web, Ganglia Server and NTP"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "ganglia_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.openlava_master_ports.id}"
}

resource "openstack_networking_secgroup_rule_v2" "ganglia_server_tcp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8649
  port_range_max    = 8649
  remote_ip_prefix  = "${var.subnet_network_block}"
  security_group_id = "${openstack_networking_secgroup_v2.openlava_master_ports.id}"
}

resource "openstack_networking_secgroup_rule_v2" "ganglia_server_udp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 8649
  port_range_max    = 8649
  remote_ip_prefix  = "${var.subnet_network_block}"
  security_group_id = "${openstack_networking_secgroup_v2.openlava_master_ports.id}"
}

resource "openstack_networking_secgroup_rule_v2" "ntp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 123
  port_range_max    = 123
  remote_ip_prefix  = "${var.subnet_network_block}"
  security_group_id = "${openstack_networking_secgroup_v2.openlava_master_ports.id}"
}

resource "openstack_networking_secgroup_v2" "openlava_ganglia_client" {
  name                 = "${var.name}_ganglia_client"
  description          = "Allows traffic to the Ganglia client"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "ganglia_client" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 8649
  port_range_max    = 8649
  remote_ip_prefix  = "${var.subnet_network_block}"
  security_group_id = "${openstack_networking_secgroup_v2.openlava_ganglia_client.id}"
}
