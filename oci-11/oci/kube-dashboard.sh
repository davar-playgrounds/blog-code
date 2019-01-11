#!/bin/bash
CLUSTER_OCID={put-here-the-cluster-ocid}
REGION={put-here-your-region} # For example: eu-frankfurt-1

# Download the config for your cluster using OCI CLI
mkdir ~/.kube
oci ce cluster create-kubeconfig --cluster-id $CLUSTER_OCID --file ~/.kube/config --region "$REGION"
# Run the dashboard locally
export KUBECONFIG=~/.kube/config
kubectl proxy &
# Go to http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login
# Use the .kube/config to sign in
