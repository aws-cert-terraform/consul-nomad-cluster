
###############################################################################
#
# Specify provider
#
###############################################################################


provider "digitalocean" {
  token = "${var.do_token}"
}

provider "ignition" {}

resource "digitalocean_droplet" "gateway" {
  image = "coreos-stable"
  name = "gateway-server-${format(count.index)}"
  region = "${var.do_region}"
  private_networking = true
  size = "${var.size_worker}"
  ssh_keys = ["${split(",", var.ssh_fingerprint)}"]
  count = "1"
  tags   = ["consul", "gateway"]
  // outputting the ignition looks like this: `ct < consul.yaml > ./output/ignition.json`
  user_data = "${file("ct/output/gateway.json")}"
}

resource "digitalocean_droplet" "consul_master" {
  image = "coreos-stable"
  name = "consul-server-${format(count.index)}"
  region = "${var.do_region}"
  private_networking = true
  size = "${var.size_master}"
  ssh_keys = ["${split(",", var.ssh_fingerprint)}"]
  count = "2"
  tags   = ["consul"]
  user_data = "${file("ct/output/consul.json")}"
}

output "cluster-private-ips" {
  value = "${formatlist("%v", digitalocean_droplet.consul_master.*.ipv4_address_private)}"
}

output "cluster-public-ips" {
  value = "${formatlist("ssh core@%v", digitalocean_droplet.consul_master.*.ipv4_address)}"
}

resource "digitalocean_loadbalancer" "public" {
  name = "lb"
  region = "nyc3"

  forwarding_rule {
    entry_port = 80
    entry_protocol = "http"

    target_port = 9901
    target_protocol = "http"
  }

  healthcheck {
    port = 22
    protocol = "tcp"
  }

  droplet_ids = ["${digitalocean_droplet.consul_master.*.id}"]
}
