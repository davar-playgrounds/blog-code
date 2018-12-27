data "oci_identity_availability_domains" "ads" {
  compartment_id = "${var.tenancy_ocid}"
}
locals {
  ad_1_name = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[0],"name")}"
  ad_2_name = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[1],"name")}"
  ad_3_name = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[2],"name")}"
}
