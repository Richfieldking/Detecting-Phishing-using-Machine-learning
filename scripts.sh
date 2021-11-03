# #!/bin/bash

# #DEFINE VARIABLES
# #FOR APPLICATION
PORT=8080
INGRESS=all
MEMORY=4Gi
RUNTIME=python38
REGION=us-central1 #CHANGE
PROJECT=debtrust001 #CHANGE
BUCKET_CLASS=standard
SERVICE_ACCOUNT=murl-detection-svc
IMAGE_NAME=malicious-url-detection
SERVICE_NAME=malicious-url-detection
BUCKET="machine-learning-model-001"
BUCKET_NAME="gs://${PROJECT}-${BUCKET}"

# #ENABLE CLOUD API SERVICES
echo "START TO ENABLE APIS"
gcloud services enable containerregistry.googleapis.com --project=$PROJECT
gcloud services enable run.googleapis.com --project=$PROJECT
echo "AFTER SUCCESSFULLY ENABLING APIS"

echo "START CREATING SERVICE ACCOUNT AND BIND TO PROJECT"
gcloud iam service-accounts create $SERVICE_ACCOUNT \
--description="Malicious url detection in websites" --display-name="murl-detection-svc"
echo "AFTER CREATING SERVICE ACCOUNT AND BIND TO A PROJECT"

#Give storage admin access to our service account
gcloud projects add-iam-policy-binding $PROJECT \
--member=serviceAccount:$SERVICE_ACCOUNT@$PROJECT.iam.gserviceaccount.com \
--role="roles/storage.admin"
echo "AFTER CREATING SERVICE ACCOUNT AND BIND TO A PROJECT"

#CREATE STORAGE BUCKET TO SAVE IMAGES
echo "START CREATING BUCKET"
gsutil mb -c $BUCKET_CLASS -l $REGION  -p $PROJECT $BUCKET_NAME
gsutil cp func/*.pkl $BUCKET_NAME
echo "END STORAGE OPERATIONS"

# #BUILD, TAG AND PUSH IMAGE TO GOOGLE CONTAINER REGISTORY
echo "START BUILDING DOCKER IMAGE"
docker image build -f configs/dockerfile -t $IMAGE_NAME .
docker image tag $IMAGE_NAME gcr.io/$PROJECT/$IMAGE_NAME
docker image push gcr.io/$PROJECT/$IMAGE_NAME
echo "AFTER IMAGE HAS BEEN PUSHED"

#DEPLOY APPLICATION AS CLOUDRUN APP
echo "START DEPLOYING APPLICATION"
gcloud run deploy $SERVICE_NAME --image=gcr.io/$PROJECT/$IMAGE_NAME:latest --memory=$MEMORY --port=$PORT \
--region=$REGION --ingress=$INGRESS --set-env-vars "BUCKET_NAME=${PROJECT}-${BUCKET}","PROJECT_NAME=${PROJECT}" \
--allow-unauthenticated --project=$PROJECT --service-account=$SERVICE_ACCOUNT@$PROJECT.iam.gserviceaccount.com
echo "AFTER DEPLOYING APPLICATION"
#sudo lsof -i -P -n | grep LISTEN
