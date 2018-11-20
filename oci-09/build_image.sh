#!/bin/bash
# Customize here
custom_image_shape="VM.Standard2.1"
custom_image_base="CentOS-7-2018.10.12-0"
custom_image_name="$custom_image_base-Node.js-v10.0.0"
export TF_VAR_compartment_ocid=ocid1.compartment.oc1..aaaaaaaavpjjlshvlm7nh6gxuhbsdzdbvhuiihenvyaqz6o4hrycscjtq75q

# Provisioning image building VM
export TF_VAR_custom_image_shape="$custom_image_shape"
export TF_VAR_custom_image_base="$custom_image_base"
cd infrastructure
terraform init
echo "IB: Provisioning image building infrastructure"
terraform apply -auto-approve 2>&1 | tee ../terraform.out
vm_ip=`cat ../terraform.out | grep image_builder_vm_public_ip | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+'`
vm_ocid=`cat ../terraform.out | grep image_builder_vm_ocid | awk '{print $3}'`
echo "IB ip: $vm_ip ocid: $vm_ocid"
cd ..
echo "IB: Waiting for SSH on VM"
./scripts/wait_for_ssh_on_vm.sh

# Executing custom image specific scripts
echo "IB: Executing image building script"
ssh -i keys/oci_id_rsa -o StrictHostKeyChecking=no -l opc $vm_ip "bash -s" < scripts/image_building_simple.sh
echo "IB: Ready"

# Creating an image
oci compute image create --display-name $custom_image_name --instance-id "$vm_ocid" --wait-for-state AVAILABLE

# Terminating the image building VM
cd infrastructure
terraform destroy -auto-approve
unset TF_VAR_custom_image_shape
unset TF_VAR_custom_image_base
unset TF_VAR_compartment_ocid
