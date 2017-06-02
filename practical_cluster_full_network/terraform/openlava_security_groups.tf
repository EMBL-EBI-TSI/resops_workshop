resource "openstack_compute_secgroup_v2" "openlava_basic_sec" {
  name        = "${var.name}_basic_sec"
  description = "Allows SSH & ICMP"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_secgroup_v2" "openlava_cluster" {
  name        = "${var.name}_cluster"
  description = "Allows OpenLava ports"

  rule {
    from_port   = 1024
    to_port     = 65535
    ip_protocol = "tcp"
    self        = true
  }

  rule {
    from_port   = 6322
    to_port     = 6322
    ip_protocol = "udp"
    self        = true
  }
}

resource "openstack_compute_secgroup_v2" "openlava_NFSv4" {
  name        = "${var.name}_NFSv4"
  description = "Allows NFSv4"

  rule {
    from_port   = 2049
    to_port     = 2049
    ip_protocol = "tcp"
    cidr        = "${var.subnet_network_block}"
  }
}

resource "openstack_compute_secgroup_v2" "openlava_HTTP" {
  name        = "${var.name}_HTTP"
  description = "Allows HTTP from outside to access Ganglia"

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_secgroup_v2" "openlava_ganglia_server" {
  name        = "${var.name}_ganglia_server"
  description = "Allows traffic to the Ganglia Server"

  rule {
    from_port   = 8649
    to_port     = 8649
    ip_protocol = "tcp"
    cidr        = "${var.subnet_network_block}"
  }

  rule {
    from_port   = 8649
    to_port     = 8649
    ip_protocol = "udp"
    cidr        = "${var.subnet_network_block}"
  }
}

resource "openstack_compute_secgroup_v2" "openlava_ganglia_client" {
  name        = "${var.name}_ganglia_client"
  description = "Allows traffic to the Ganglia client"

  rule {
    from_port   = 8649
    to_port     = 8649
    ip_protocol = "udp"
    cidr        = "${var.subnet_network_block}"
  }
}

resource "openstack_compute_secgroup_v2" "openlava_NTP" {
  name        = "${var.name}_NTP"
  description = "Allows NTP traffic"

  rule {
    from_port   = 123
    to_port     = 123
    ip_protocol = "tcp"
    cidr        = "${var.subnet_network_block}"
  }
}
