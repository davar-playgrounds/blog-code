# Route Tables
resource "oci_core_route_table" "oke_cluster_rt" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${var.vcn_ocid}"
  display_name = "oke-rt"
  route_rules {
    destination = "0.0.0.0/0"
    network_entity_id = "${var.vcn_igw_ocid}"
  }
}

# Security List
resource "oci_core_security_list" "oke_workers_sl" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${var.vcn_ocid}"
  display_name = "oke-workers-sl"
  egress_security_rules = [
    { stateless = "true" destination = "${var.oke_cluster["cidr"]}" protocol = "all"},
    { destination = "0.0.0.0/0" protocol = "all"}

  ]
  ingress_security_rules = [
    { stateless = "true" source = "${var.oke_cluster["cidr"]}" protocol = "all"},
    { protocol = "6", source = "${var.oke_engine_cidr[0]}", tcp_options { "max" = 22, "min" = 22 }},
    { protocol = "6", source = "${var.oke_engine_cidr[1]}", tcp_options { "max" = 22, "min" = 22 }},
    { protocol = "6", source = "0.0.0.0/0", tcp_options { "min" = 30000, "max" = 32767 }}
  ]
}

resource "oci_core_security_list" "oke_loadbalancers_sl" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${var.vcn_ocid}"
  display_name = "oke-loadbalancers-sl"
  egress_security_rules = [
    { stateless = "true" destination = "${var.oke_cluster["cidr"]}" protocol = "all"},
    { stateless = "true" destination = "0.0.0.0/0" protocol = "all"}
  ]
  ingress_security_rules = [
    { stateless = "true" source = "${var.oke_cluster["cidr"]}" protocol = "all"},
    { stateless = "true" protocol = "6", source = "0.0.0.0/0", tcp_options { "min" = 30000, "max" = 32767 }}
  ]
}

# Subnets
resource "oci_core_subnet" "oke_workers_ad1_net" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${var.vcn_ocid}"
  display_name = "oke-workers-ad1-net"
  availability_domain = "${var.ads[0]}"
  cidr_block = "${var.oke_wn_subnet_cidr[0]}"
  route_table_id = "${oci_core_route_table.oke_cluster_rt.id}"
  security_list_ids = ["${oci_core_security_list.oke_workers_sl.id}"]
  dhcp_options_id = "${var.vcn_dhcp_options_ocid}"
  dns_label = "work1"
}

resource "oci_core_subnet" "oke_workers_ad2_net" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${var.vcn_ocid}"
  display_name = "oke-workers-ad2-net"
  availability_domain = "${var.ads[1]}"
  cidr_block = "${var.oke_wn_subnet_cidr[1]}"
  route_table_id = "${oci_core_route_table.oke_cluster_rt.id}"
  security_list_ids = ["${oci_core_security_list.oke_workers_sl.id}"]
  dhcp_options_id = "${var.vcn_dhcp_options_ocid}"
  dns_label = "work2"
}

resource "oci_core_subnet" "oke_loadbalancers_ad1_net" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${var.vcn_ocid}"
  display_name = "oke-loadbalancers-ad1-net"
  availability_domain = "${var.ads[0]}"
  cidr_block = "${var.oke_lb_subnet_cidr[0]}"
  route_table_id = "${oci_core_route_table.oke_cluster_rt.id}"
  security_list_ids = ["${oci_core_security_list.oke_loadbalancers_sl.id}"]
  dhcp_options_id = "${var.vcn_dhcp_options_ocid}"
  dns_label = "lb1"
}

resource "oci_core_subnet" "oke_loadbalancers_ad2_net" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${var.vcn_ocid}"
  display_name = "oke-loadbalancers-ad2-net"
  availability_domain = "${var.ads[1]}"
  cidr_block = "${var.oke_lb_subnet_cidr[1]}"
  route_table_id = "${oci_core_route_table.oke_cluster_rt.id}"
  security_list_ids = ["${oci_core_security_list.oke_loadbalancers_sl.id}"]
  dhcp_options_id = "${var.vcn_dhcp_options_ocid}"
  dns_label = "lb2"
}
