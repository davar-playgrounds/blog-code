module "k8s" {
  source = "k8s"
  compartment_ocid = "${var.compartment_ocid}"
  ads = [ "${local.ad_1_name}", "${local.ad_2_name}" ]
  vcn_ocid = "${oci_core_virtual_network.main_vcn.id}"
  vcn_igw_ocid = "${oci_core_internet_gateway.main_igw.id}"
  vcn_dhcp_options_ocid = "${oci_core_virtual_network.main_vcn.default_dhcp_options_id}"
}
