###############################################################################
#
# Get variables from command line or environment
#
###############################################################################


variable "do_token" {
    default = "..."
}


variable "do_region" {
    default = "nyc3"
}
variable "ssh_fingerprint" {
    default = [ "12:b8:e6:0a:a9:12:e6:9e:bd:6c:ba:c9:02:bb:f0:65" ]
}

variable "ssh_private_key" {
    default = "~/.ssh/gate-key"
}

variable "number_of_workers" {
	default = "1"
}

variable "k8s_version" {
	default = "v1.10.3"
}

variable "cni_version" {
	default = "v0.6.0"
}

variable "prefix" {
    default = ""
}

variable "size_master" {
    default = "2gb"
}

variable "size_worker" {
    default = "2gb"
}
