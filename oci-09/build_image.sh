#!/bin/bash
# Customize here
cd ~/git/blog-code/oci-09
custom_image_shape="VM.Standard2.1"
custom_image_base="CentOS-7-2018.10.12-0"
custom_image_name="$custom_image_base-Node.js-v10.0.0"

# Provisioning image building VM and executing custom image specific scripts
export TF_VAR_custom_image_shape="$custom_image_shape"
export TF_VAR_custom_image_base="$custom_image_base"
cd infrastructure
terraform init
echo "IB: Provisioning image building infrastructure"
terraform apply -auto-approve > ../terraform.out
vm_ip=`cat ../terraform.out | grep image_builder_vm_public_ip | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+'`
vm_ocid=`cat ../terraform.out | grep image_builder_vm_ocid | awk '{print $3}'`
echo "IB ip: $vm_ip ocid: $vm_ocid"
cd ..
echo "IB: Waiting for SSH on VM"
./scripts/wait_for_ssh_on_vm.sh
echo "IB: Executing image building script"
#ssh -o StrictHostKeyChecking=no -l opc $vm_ip "bash -s" < scripts/image_building.sh
echo "IB: Ready"

# Creating an image
oci compute image create --display-name $custom_image_name --instance-id "$vm_ocid" --wait-for-state AVAILABLE

# Terminating the image building VM
cd infrastructure
terraform destroy
