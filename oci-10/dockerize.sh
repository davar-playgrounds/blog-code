#!/bin/bash
# Customize here - OCI details
OCI_PROJECT_CODE={put-here-your-project-code}
OCI_TENANCY={put-here-your-tenancy-name}
OCIR_REGION={put-here-your-region}
OCI_USER={put-here-the-user-name}
# Customize here - your Docker image details
IMAGE_NAME=simple-api
IMAGE_TAG=1.0

# Push the image into Oracle Container Image Registry
cd app
docker build -t $IMAGE_NAME:$IMAGE_TAG .
docker tag $IMAGE_NAME:$IMAGE_TAG $OCIR_REGION.ocir.io/$OCI_TENANCY/p-$OCI_PROJECT_CODE-$IMAGE_NAME:$IMAGE_TAG
docker login -u $OCI_TENANCY/$OCI_USER $OCIR_REGION.ocir.io
### You will be prompted for the auth token here
docker push $OCIR_REGION.ocir.io/$OCI_TENANCY/p-$OCI_PROJECT_CODE-$IMAGE_NAME:$IMAGE_TAG
