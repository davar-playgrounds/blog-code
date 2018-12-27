variable "compartment_ocid" {}
variable "vcn_ocid" {}
variable "vcn_igw_ocid" {}
variable "vcn_dhcp_options_ocid" {}
variable "ads" { type="list" default = [] }

variable "oke_cluster" {
  type = "map"
  default = {
    cidr = "10.1.1.0/24"
    version = "v1.11.5"
    worker_image = "Oracle-Linux-7.5"
    worker_shape = "VM.Standard2.1"
    worker_nodes_in_subnet = 1
    pods_cidr = "10.244.0.0/16"
    services_cidr = "10.96.0.0/16"
  }
}
variable "oke_wn_subnet_cidr" { type = "list" default = [ "10.1.1.64/26", "10.1.1.128/26" ] }
variable "oke_lb_subnet_cidr" { type = "list" default = [ "10.1.1.0/28", "10.1.1.16/28" ] }
variable "oke_engine_cidr" { type = "list" default = [ "130.35.0.0/16", "138.1.0.0/17"] }
