#!/bin/bash
# Customize here
OCI_POLICY_COMPARTMENT_OCID={put-here-your-compartment-OCID-for-policy}
OCI_PROJECT_CODE={put-here-your-project-code}
OCI_POLICY_NAME="p-$OCI_PROJECT_CODE-ocir-policy"
OCI_POLICY_DESC="$OCI_PROJECT_CODE project OCIR policy"
OCI_GROUP="$OCI_PROJECT_CODE-developers"
OCI_PROJECT_PREFIX="p-$OCI_PROJECT_CODE"

# Add a new policy statements to let group member manage OCIR repositories with a specific naming pattern
OCI_POLICY_MANAGE="allow group $OCI_GROUP to manage repos in tenancy where target.repo.name = /$OCI_PROJECT_PREFIX-*/"
oci iam policy create -c $OCI_POLICY_COMPARTMENT_OCID --name $OCI_POLICY_NAME --description "$OCI_POLICY_DESC" --statements "[ \"$OCI_POLICY_MANAGE\" ]"

# Alternatively you can additionally let user see a list of all images in OCIR (only names):
# OCI_POLICY_INSPECT="allow group $OCI_GROUP to inspect repos in tenancy where request.operation='ListDockerRepositories'"
# OCI_POLICY_MANAGE="allow group $OCI_GROUP to manage repos in tenancy where target.repo.name = /$OCI_PROJECT_PREFIX-*/"
# oci iam policy create -c $OCI_POLICY_COMPARTMENT_OCID --name $OCI_POLICY_NAME --description "$OCI_POLICY_DESC" --statements "[ \"$OCI_POLICY_INSPECT\", \"$OCI_POLICY_MANAGE\" ]"
