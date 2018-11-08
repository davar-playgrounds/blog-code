#
variable "compartment_ocid" {}
variable "custom_image_shape" {}
variable "custom_image_base" {}

# VCN
resource "oci_core_virtual_network" "image_builder_vcn" {
  compartment_id = "${var.compartment_ocid}"
  display_name = "ib-vcn"
  cidr_block = "192.168.1.0/24"
}

resource "oci_core_internet_gateway" "image_builder_igw" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.image_builder_vcn.id}"
  display_name = "ib-igw"
  enabled = "true"
}

resource "oci_core_route_table" "image_builder_rt" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.image_builder_vcn.id}"
  display_name = "ib-rt"
  route_rules {
    destination = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.image_builder_igw.id}"
  }
}

resource "oci_core_security_list" "image_builder_sl" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.image_builder_vcn.id}"
  display_name = "ib-sl"
  egress_security_rules = [
    { destination = "0.0.0.0/0" protocol = "all"}
  ]
  ingress_security_rules = [
    { protocol = "6", source = "0.0.0.0/0", tcp_options { "max" = 22, "min" = 22 }}
  ]
}

resource "oci_core_subnet" "image_builder_subnet" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.image_builder_vcn.id}"
  display_name = "ib-subnet"
  availability_domain = "${local.ad_1_name}"
  cidr_block = "192.168.1.0/30"
  route_table_id = "${oci_core_route_table.image_builder_rt.id}"
  security_list_ids = ["${oci_core_security_list.image_builder_sl.id}"]
  dhcp_options_id = "${oci_core_virtual_network.image_builder_vcn.default_dhcp_options_id}"
}

# locals.tf
data "oci_identity_availability_domains" "ads" {
  compartment_id = "${var.tenancy_ocid}"
}
locals {
  ad_1_name = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[0],"name")}"
  ad_2_name = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[1],"name")}"
  ad_3_name = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[2],"name")}"
}

data "oci_core_images" "linux_image" {
  compartment_id = "${var.tenancy_ocid}"
  display_name = "${var.custom_image_base}"
}
locals {
  linux_image_ocid = "${lookup(data.oci_core_images.linux_image.images[0],"id")}"
}

# Compute
resource "oci_core_instance" "image_builder_vm" {
  compartment_id = "${var.compartment_ocid}"
  display_name = "ib-vm"
  availability_domain = "${local.ad_1_name}"

  source_details {
    source_id = "${local.linux_image_ocid}"
    source_type = "image"
  }
  shape = "${var.custom_image_shape}"
  create_vnic_details {
    subnet_id = "${oci_core_subnet.image_builder_subnet.id}"
    display_name = "primary-vnic"
    assign_public_ip = true
    private_ip = "192.168.1.2"
  }
  metadata {
    ssh_authorized_keys = "${file("~/.ssh/oci_id_rsa.pub")}"
  }
  timeouts {
    create = "5m"
  }
}

### output
data "oci_core_instance" "data_image_builder_vm" {
  instance_id = "${oci_core_instance.image_builder_vm.id}"
}
output "image_builder_vm_public_ip" {
  value = "${data.oci_core_instance.data_image_builder_vm.public_ip}"
}
output "image_builder_vm_ocid" {
  value = "${data.oci_core_instance.data_image_builder_vm.id}"
}
