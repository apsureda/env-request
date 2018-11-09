#!/bin/bash -x

# Business Unoit to which belongs the employee requesting the sanbox
DFT_BU="ddt"
# Employee's user identifier. This will appear in the project name.
DFT_SANDBOX_USER_ID="dritchie"
# Employee's email address, as defined in Active Directory.
DFT_SANDBOX_USER_EMAIL="Dennis.Ritchie@apszaz.com"

PROJECT="dft-${DFT_BU}-sb-${DFT_SANDBOX_USER_ID}"
FOLDER="710298211377"
BILLING_ACCOUNT="0131D6-94FD9F-065EAB"
REGION="europe-west2"

# Name of groups with access to the project
TEAM_DEV="gcp-ddt-developers@apszaz.com"
TEAM_OPS="gcp-ddt-ops@apszaz.com"
TEAM_MNG="gcp-ddt-mamagers@apszaz.com"

# create the project and enable billing
gcloud projects create "$PROJECT" --folder=$FOLDER
gcloud beta billing projects link $PROJECT --billing-account=$BILLING_ACCOUNT

# GCP services required by this application (GAE flex is appengineflex.googleapis.com)
GCP_SERVICES="appengine.googleapis.com \
              sql-component.googleapis.com \
              storage-api.googleapis.com \
              storage-component.googleapis.com \
              cloudkms.googleapis.com \
              cloudbuild.googleapis.com \
              iap.googleapis.com \
              sourcerepo.googleapis.com"

# enable App engine API
# To see grantable roles:  gcloud iam list-grantable-roles //cloudresourcemanager.googleapis.com/projects/$PROJECT
#gcloud services list --project=$PROJECT # See list of enabled services
gcloud services enable $GCP_SERVICES --project=$PROJECT

#gcloud iam list-grantable-roles //cloudresourcemanager.googleapis.com/projects/$PROJECT --filter="(title~'Owner')"

# create the App Engine app
gcloud app create --region=$REGION --project=$PROJECT

# Apply the appropriate permissions at the project level
gcloud projects add-iam-policy-binding $PROJECT --member=user:$DFT_SANDBOX_USER_EMAIL --role=roles/owner
gcloud projects add-iam-policy-binding $PROJECT --member=group:$TEAM_DEV --role=roles/viewer
gcloud projects add-iam-policy-binding $PROJECT --member=group:$TEAM_OPS --role=roles/owner
gcloud projects add-iam-policy-binding $PROJECT --member=group:$TEAM_MNG --role=roles/owner

