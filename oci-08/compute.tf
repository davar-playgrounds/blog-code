# compute.tf
resource "oci_core_instance" "demo_vm" {
  compartment_id = "${var.compartment_ocid}"
  display_name = "demo-vm"
  availability_domain = "${local.ad_1_name}"

  source_details {
    source_id = "${local.centos_linux_image_ocid}"
    source_type = "image"
  }
  shape = "VM.Standard2.1"
  create_vnic_details {
    subnet_id = "${oci_core_subnet.demo_subnet.id}"
    display_name = "primary-vnic"
    assign_public_ip = true
    private_ip = "192.168.10.2"
    hostname_label = "michalsvm"
  }
  metadata {
    ssh_authorized_keys = "${file("~/.ssh/oci_id_rsa.pub")}"
    user_data = "${base64encode(file("./cloud-init/vm.cloud-config"))}"
  }
  timeouts {
    create = "5m"
  }
}
