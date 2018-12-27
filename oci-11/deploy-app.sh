#!/bin/bash
OCI_TENANCY={put-here-your-tenancy-name}
# OCIR Regions: fra (Frankfurt), lhr (London), phx (Phoenix), iad (Ashburn)
OCIR_REGION={put-here-your-region}
# OCI Regions: eu-frankfurt-1, uk-london-1, ...
OCI_REGION={put-here-your-region}
OCI_USER={put-here-the-user-name}
OCI_USER_OCID={put-here-the-user-ocid}
OCI_USER_EMAIL={put-here-the-user-email}
CLUSTER_OCID={put-here-the-cluster-ocid}

# Download cluster's kubeconfig and run a local Kubernetes Dashboard
export KUBECONFIG=~/.kube/config
mkdir ~/.kube
oci ce cluster create-kubeconfig --cluster-id $CLUSTER_OCID --file $KUBECONFIG --region $OCI_REGION
kubectl proxy &

# Let Kubernetes pull images from Oracle Container Image Registry
TOKEN=`oci iam auth-token create --user-id "$OCI_USER_OCID" --description K8sToken | grep token | awk -F"[\"\"]" '{print $4}'`
kubectl create secret docker-registry ocirsecret --docker-server="$OCIR_REGION.ocir.io" --docker-username="$OCI_TENANCY/$OCI_USER" --docker-password="$TOKEN" --docker-email="$OCI_USER_EMAIL"

# Create Pod-based Deployment and LoadBalanced Service
kubectl create -f app/simpleapi-deployment.yaml
kubectl create -f app/simpleapi-service.yaml
