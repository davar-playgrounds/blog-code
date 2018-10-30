# vcn.tf
resource "oci_core_virtual_network" "demo_vcn" {
  compartment_id = "${var.compartment_ocid}"
  display_name = "demo-vcn"
  cidr_block = "192.168.10.0/24"
  dns_label = "demovcn"
}

resource "oci_core_internet_gateway" "demo_igw" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.demo_vcn.id}"
  display_name = "demo-igw"
  enabled = "true"
}

resource "oci_core_route_table" "demo_rt" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.demo_vcn.id}"
  display_name = "demo-rt"
  route_rules {
    destination = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.demo_igw.id}"
  }
}

resource "oci_core_security_list" "demo_sl" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.demo_vcn.id}"
  display_name = "demo-sl"
  egress_security_rules = [
    { destination = "0.0.0.0/0" protocol = "all"}
  ]
  ingress_security_rules = [
    { protocol = "6", source = "0.0.0.0/0", tcp_options { "max" = 22, "min" = 22 }},
    { protocol = "6", source = "0.0.0.0/0", tcp_options { "max" = 80, "min" = 80 }}
  ]
}

resource "oci_core_subnet" "demo_subnet" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.demo_vcn.id}"
  display_name = "demo-subnet"
  availability_domain = "${local.ad_1_name}"
  cidr_block = "192.168.10.0/30"
  route_table_id = "${oci_core_route_table.demo_rt.id}"
  security_list_ids = ["${oci_core_security_list.demo_sl.id}"]
  dhcp_options_id = "${oci_core_virtual_network.demo_vcn.default_dhcp_options_id}"
  dns_label = "demosubnet"
}
