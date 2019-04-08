
###############################################################################
#
# Specify provider
#
###############################################################################


provider "digitalocean" {
    token = "${var.do_token}"
}

provider "ignition" {}


###############################################################################
#
# Master host
#
###############################################################################

# Systemd unit data resource containing the unit definition
// data "ignition_systemd_unit" "example" {
//     name = "example.service"
//     content = "${file("unit-files/example.service")}"
// }

// # Systemd unit data resource containing the unit definition
// data "ignition_systemd_unit" "example" {
//   name = "example.service"
//   content = "[Service]\nType=oneshot\nExecStart=/usr/bin/echo Hello World\n\n[Install]\nWantedBy=multi-user.target"
// }

# Systemd unit data resource containing the unit definition
// data "ignition_systemd_unit" "consul" {
//     name = "consul.service"
//     content = "${file("unit-files/consul.service")}"
// }

# Systemd unit data resource containing the unit definition
// data "ignition_systemd_unit" "example2" {
//     name = "example2.service"
//     content = "${file("unit-files/example2.service")}"
// }


#"${data.ignition_systemd_unit.example.id}",
# Ingnition config include the previous defined systemd unit data resource
// data "ignition_config" "example_config" {
//     systemd = [
//         "${data.ignition_systemd_unit.example.id}",
//         "${data.ignition_systemd_unit.consul.id}",
//     ]
// }

resource "digitalocean_droplet" "consul_master" {
    image = "coreos-stable"
    name = "consul-server-${format(count.index)}"
    region = "${var.do_region}"
    private_networking = true
    size = "${var.size_master}"
    ssh_keys = ["${split(",", var.ssh_fingerprint)}"]
    count = "2"
    tags   = ["consul"]
    user_data = "${file("ct/output/ignition.json")}"
}

output "cluster-private-ips" {
  value = "${formatlist("%v", digitalocean_droplet.consul_master.*.ipv4_address_private)}"
}

output "cluster-public-ips" {
  value = "${formatlist("ssh core@%v", digitalocean_droplet.consul_master.*.ipv4_address)}"
}
