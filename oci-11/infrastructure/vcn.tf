resource "oci_core_virtual_network" "main_vcn" {
  compartment_id = "${var.compartment_ocid}"
  display_name = "main-vcn"
  cidr_block = "${var.vcn_cidr}"
  dns_label = "mainvcn"
}

resource "oci_core_internet_gateway" "main_igw" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.main_vcn.id}"
  display_name = "main-igw"
  enabled = "true"
}
