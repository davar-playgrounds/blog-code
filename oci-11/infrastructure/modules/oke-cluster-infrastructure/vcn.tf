
# 192.168.1.0/26 (1-62)
# -- 192.168.1.0/28 (1-15) LB1
# -- 192.168.1.16 (17-30) LB2
# -- 192.168.1.32 (33-46)
# -- 192.168.1.48 (49-62)
# 192.168.1.64/26 (65-126) WN1
# 192.168.1.128/26 (129-190) WN1
# 192.168.1.192/26 (193-254) WN1
variable "compartment_ocid" {}
variable "oke_cluster_cidr" { type = "string" default = "192.168.1.0/24" }
variable "oke_lb_subnet_cidr" { type = "list" default = [ "192.168.1.64/26", "192.168.1.128/26", "192.168.1.192/26" ] }
variable "oke_wn_subnet_cidr" { type = "list" default = [ "192.168.1.0/28", "192.168.1.16/28" ] }
variable "oke_engine_cidr" { type = "list" default = [ "130.35.0.0/16", "138.1.0.0/17"] }

# VCN
resource "oci_core_virtual_network" "oke_vcn" {
  compartment_id = "${var.compartment_ocid}"
  display_name = "oke-vcn"
  cidr_block = "${var.oke_cluster_cidr}"
}

resource "oci_core_internet_gateway" "oke_igw" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.oke_vcn.id}"
  display_name = "oke-igw"
  enabled = "true"
}

# Route Tables
resource "oci_core_route_table" "oke_cluster_rt" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.oke_vcn.id}"
  display_name = "oke-rt"
  route_rules {
    destination = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.oke_igw.id}"
  }
}

# Security List
resource "oci_core_security_list" "oke_workers_sl" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.oke_vcn.id}"
  display_name = "oke-workers-sl"
  egress_security_rules = [
    { stateless = "true" destination = "${var.oke_cluster_cidr}" protocol = "all"},
    { destination = "0.0.0.0/0" protocol = "all"}

  ]
  ingress_security_rules = [
    { stateless = "true" source = "${var.oke_cluster_cidr}" protocol = "all"},
    { protocol = "6", source = "${var.oke_engine_cidr[0]}", tcp_options { "max" = 22, "min" = 22 }},
    { protocol = "6", source = "${var.oke_engine_cidr[1]}", tcp_options { "max" = 22, "min" = 22 }},
    { protocol = "6", source = "0.0.0.0/0", tcp_options { "min" = 30000, "max" = 32767 }}
  ]
}

resource "oci_core_security_list" "oke_loadbalancers_sl" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.oke_vcn.id}"
  display_name = "oke-loadbalancers-sl"
  egress_security_rules = [
    { stateless = "true" destination = "${var.oke_cluster_cidr}" protocol = "all"},
    { destination = "0.0.0.0/0" protocol = "all"}

  ]
  ingress_security_rules = [
    { stateless = "true" source = "${var.oke_cluster_cidr}" protocol = "all"},
    { protocol = "6", source = "0.0.0.0/0", tcp_options { "min" = 30000, "max" = 32767 }}
  ]
}
