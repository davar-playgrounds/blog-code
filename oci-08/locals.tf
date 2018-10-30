# locals.tf
data "oci_identity_availability_domains" "ads" {
  compartment_id = "${var.tenancy_ocid}"
}
locals {
  ad_1_name = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[0],"name")}"
  ad_2_name = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[1],"name")}"
  ad_3_name = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[2],"name")}"
}

data "oci_core_images" "centos_linux_image" {
  compartment_id = "${var.tenancy_ocid}"
  operating_system = "CentOS"
}
locals {
  centos_linux_image_ocid = "${lookup(data.oci_core_images.centos_linux_image.images[0],"id")}"
}
