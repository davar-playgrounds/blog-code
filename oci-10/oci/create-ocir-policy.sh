#!/bin/bash
# Customize here
OCI_POLICY_COMPARTMENT_OCID=<put-here-your-compartment-OCID-for-policy>
OCI_POLICY_NAME="p-oraas-ocir-policy"
OCI_POLICY_DESC="Operation Research as a Service project OCIR policy"
OCI_GROUP="oraas-developers"
OCI_PROJECT_PREFIX="p-oraas"

# Add a new policy statements to let group member manage OCIR repositories with a specific naming pattern
OCI_POLICY_MANAGE="allow group $OCI_GROUP to manage repos in tenancy where target.repo.name = /$OCI_PROJECT_PREFIX-*/"
oci iam policy create -c $OCI_POLICY_COMPARTMENT_OCID --name $OCI_POLICY_NAME --description "$OCI_POLICY_DESC" --statements "[ \"$OCI_POLICY_MANAGE\" ]"

# Alternatively you can additionally let user see a list of all images in OCIR (only names):
# OCI_POLICY_INSPECT="allow group $OCI_GROUP to inspect repos in tenancy where request.operation='ListDockerRepositories'"
# OCI_POLICY_MANAGE="allow group $OCI_GROUP to manage repos in tenancy where target.repo.name = /$OCI_PROJECT_PREFIX-*/"
# oci iam policy create -c $OCI_POLICY_COMPARTMENT_OCID --name $OCI_POLICY_NAME --description "$OCI_POLICY_DESC" --statements "[ \"$OCI_POLICY_INSPECT\", \"$OCI_POLICY_MANAGE\" ]"
