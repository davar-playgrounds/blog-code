#!/bin/bash
# Customize here - OCI details
OCIR_REGION=fra
OCI_TENANCY=<put-here-your-tenancy-name>
OCI_USER=oraas-dev-1
OCI_PROJECT=p-oraas
# Customize here - Your image details
IMAGE_NAME=simple-api
IMAGE_TAG=1.1

# Push the image into Oracle Container Image Registry
git clone https://github.com/mtjakobczyk/blog-code.git
cd blog-code/oci-10/app
docker build -t $IMAGE_NAME:$IMAGE_TAG .
docker tag $IMAGE_NAME:$IMAGE_TAG $OCIR_REGION.ocir.io/$OCI_TENANCY/$OCI_PROJECT-$IMAGE_NAME:$IMAGE_TAG
docker login -u $OCI_TENANCY/$OCI_USER $OCIR_REGION.ocir.io
### You will be prompted for the auth token here
docker push $OCIR_REGION.ocir.io/$OCI_TENANCY/$OCI_PROJECT-$IMAGE_NAME:$IMAGE_TAG
