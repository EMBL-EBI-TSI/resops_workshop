resource "openstack_compute_keypair_v2" "ssh_keypair" {
  name       = "${var.name}_keypair"
  public_key = "${file("${var.DEPLOYMENT_KEY_PATH}.pub")}"
}

resource "openstack_compute_instance_v2" "openlava_master" {
  name = "${var.name}_master"

  image_id          = "${var.master_image_id}"
  flavor_name       = "${var.master_flavor}"
  key_pair          = "${openstack_compute_keypair_v2.ssh_keypair.name}"
  availability_zone = "${var.availability_zone}"

  security_groups = ["${openstack_compute_secgroup_v2.openlava_basic_sec.id}",
    "${openstack_compute_secgroup_v2.openlava_cluster.id}",
    "${openstack_compute_secgroup_v2.openlava_HTTP.id}",
    "${openstack_compute_secgroup_v2.openlava_ganglia_server.id}",
    "${openstack_compute_secgroup_v2.openlava_NTP.id}",
  ]

  network {
    name = "${var.network_name}"
  }

  metadata {
    deployment_id = "${var.name}"
  }
}

resource "openstack_blockstorage_volume_v2" "homes_volume" {
  name        = "${var.name}-homes"
  description = "Volume storing user homes for the ${var.name} cluster"
  size        = "${var.homes_size}"

  metadata {
    deployment_id = "${var.name}"
  }
}

resource "openstack_blockstorage_volume_v2" "data_volume" {
  name        = "${var.name}-data"
  description = "Volume storing data for the ${var.name} cluster"
  size        = "${var.data_volume_size}"

  metadata {
    deployment_id = "${var.name}"
  }
}

resource "openstack_compute_instance_v2" "openlava_nfs" {
  name = "${var.name}_nfs"

  image_id          = "${var.nfs_image_id}"
  flavor_name       = "${var.nfs_flavor}"
  key_pair          = "${openstack_compute_keypair_v2.ssh_keypair.name}"
  availability_zone = "${var.availability_zone}"

  security_groups = ["${openstack_compute_secgroup_v2.openlava_basic_sec.id}",
    "${openstack_compute_secgroup_v2.openlava_NFSv4.id}",
    "${openstack_compute_secgroup_v2.openlava_ganglia_client.id}",
  ]

  network {
    name = "${var.network_name}"
  }

  metadata {
    deployment_id = "${var.name}"
  }
}

resource "openstack_compute_volume_attach_v2" "homes_attach" {
  instance_id = "${openstack_compute_instance_v2.openlava_nfs.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.homes_volume.id}"
}

resource "openstack_compute_volume_attach_v2" "data_attach" {
  instance_id = "${openstack_compute_instance_v2.openlava_nfs.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.data_volume.id}"
}

resource "openstack_compute_instance_v2" "openlava_nodes" {
  count = "${var.nodes}"
  name  = "${var.name}_node_${count.index +1}"

  image_id          = "${var.node_image_id}"
  flavor_name       = "${var.node_flavor}"
  key_pair          = "${openstack_compute_keypair_v2.ssh_keypair.name}"
  availability_zone = "${var.availability_zone}"

  security_groups = ["${openstack_compute_secgroup_v2.openlava_basic_sec.id}",
    "${openstack_compute_secgroup_v2.openlava_cluster.id}",
    "${openstack_compute_secgroup_v2.openlava_ganglia_client.id}",
  ]

  network {
    name = "${var.network_name}"
  }

  metadata {
    deployment_id = "${var.name}"
  }
}

output "MASTER_IP" {
  value = "${openstack_compute_instance_v2.openlava_master.access_ip_v4}"
}
