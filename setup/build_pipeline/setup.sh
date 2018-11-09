#!/bin/bash

# IP od the project that will contain the CICD tools
PROJECT="apszaz-dft-cicd-test4"
# Folder ID where the CICD project will be located
FOLDER="815952447001"
# Billing and organization IDs.
ORGANIZATION_ID="116143322321"
BILLING_ACCOUNT="0131D6-94FD9F-065EAB"
# GitHub repository where the environment creation pipeline files will
# be stored. terraform config files will be pushed into this repository.
GITHUB_REPO="git@github.com:apsureda/env-request"
# GCS bucket where the terraform remote state will be stored.
TF_BUCKET="tfstate-$PROJECT"
# The name of the group where the service account for the environment
# creation pipeline will be added.
TEAM_CICD="gcp-global-cicd@apszaz.com"
REGION="europe-west2"

echo "Creating project $PROJECT"
gcloud projects create $PROJECT --folder=$FOLDER
gcloud beta billing projects link $PROJECT --billing-account=$BILLING_ACCOUNT

# GCP services required by this application (GAE flex is appengineflex.googleapis.com)
GCP_SERVICES="sql-component.googleapis.com \
            sqladmin.googleapis.com \
            storage-api.googleapis.com \
            storage-component.googleapis.com \
            cloudkms.googleapis.com \
            cloudbuild.googleapis.com \
            containerregistry.googleapis.com \
            cloudresourcemanager.googleapis.com \
            sourcerepo.googleapis.com"

# To see grantable roles:  gcloud iam list-grantable-roles //cloudresourcemanager.googleapis.com/projects/$PROJECT
# gcloud services list --project=$PROJECT # See list of enabled services
gcloud services enable $GCP_SERVICES --project=$PROJECT

# Grant the necessary permissions to the CICD group at the organization level.
# This is necessary so the build pipeline can create resources.
echo "Granting permissions to the CICD user group."
for role in "roles/editor" "roles/billing.projectManager" "roles/resourcemanager.folderAdmin" \
            "roles/resourcemanager.folderEditor" "roles/resourcemanager.projectCreator" \
            "roles/resourcemanager.projectDeleter" ; do
  gcloud beta organizations add-iam-policy-binding $ORGANIZATION_ID --member="group:$TEAM_CICD" --role=$role
done

# create the build trigger for the environment request GitHub repository.
create_build_trigger() {
  PROJECT_ID=$1
  REPONAME=$2
  BRANCH=$3
  FILENAME=$4
  DESCRIPTION=$5
  INT_REPONAME=$(echo $REPONAME | sed 's/git@github.com:/github_/' | sed 's/\//_/')
  BODY=$(cat <<EOF
  {
    "triggerTemplate": {
      "projectId": "$PROJECT_ID",
      "repoName": "$INT_REPONAME",
      "branchName": "$BRANCH"
    },
    "description": "$DESCRIPTION",
    "filename": "$FILENAME",
    "substitutions": {
      "_GITHUB_REPO": "$REPONAME"
    }
  }
EOF
)
  curl -X POST -H "Content-Type: application/json" \
  -d "$BODY" \
  https://cloudbuild.googleapis.com/v1/projects/$PROJECT/triggers?\
access_token=$(gcloud auth application-default print-access-token)
}

echo "Creating build triggers"
create_build_trigger $PROJECT $GITHUB_REPO "request-.*" "cloudbuild_tf_plan.yaml" "Update terraform configuration and run terraform plan."
create_build_trigger $PROJECT $GITHUB_REPO "master" "cloudbuild_tf_apply.yaml" "Apply the current terraform configuration."

# Create a crypoKey for the 
echo "Creating a cryptographic key for the build pipeline"
gcloud kms keyrings create CLOUDBUILD-SECRETS --location=global --project=$PROJECT
gcloud kms keys create CLOUDBUILD-KEY --location=global --keyring=CLOUDBUILD-SECRETS \
--purpose=encryption --project=$PROJECT

# give decrypt rights to the cloud build pipeline
echo "Granting permissions on the key to the CICD user group"
for role in "roles/cloudkms.cryptoKeyDecrypter" "roles/cloudkms.cryptoKeyEncrypter"\
            "roles/cloudkms.admin"; do
  gcloud kms keys add-iam-policy-binding CLOUDBUILD-KEY --location=global \
         --keyring=CLOUDBUILD-SECRETS --member=group:$TEAM_CICD \
        --role=$role  --project=$PROJECT
done

# encrypt your GitHub SSH private key using command:
#   gcloud kms encrypt --plaintext-file=in_rsa --ciphertext-file=in_rsa.enc --location=global \
#          --keyring=CLOUDBUILD-SECRETS --key=CLOUDBUILD-KEY --project=$PROJECT
# more details on configuring github access:
#   https://cloud.google.com/cloud-build/docs/access-private-github-repos

# Create a GCS bucket for terraform remote storage
echo "Creating GCS bucket for the terraform remote state"
gsutil mb -l $REGION -p $PROJECT gs://$TF_BUCKET/ 
gsutil iam ch group:$TEAM_CICD:objectAdmin gs://$TF_BUCKET

# build the custDocker images for the custom build steps
echo "Creating containers for our custon builders"
PREV_DIR=$(pwd)
cd  custom_builders/Python
gcloud builds submit . --config=cloudbuild.yaml --project=$PROJECT
cd "$PREV_DIR"
cd  custom_builders/terraform
gcloud builds submit . --config=cloudbuild.yaml --project=$PROJECT
cd "$PREV_DIR"


# Output remaining config steps
PROJECT_NUMBER=$(gcloud projects describe $PROJECT --format="value(projectNumber)")
CLOUDBUILD_SERV_ACC="${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com"
cat <<EOF
You are almost done, but there are still a few things to do:

1.- Edit the config.yaml file, and change the gcs_bucket parameter to $TF_BUCKET
2.- Create a GitHub authentication key, and encrypt it using Cloud KMS. See:
    https://cloud.google.com/cloud-build/docs/access-private-github-repos
3.- Add the Cloud Build service account to the CICD group:
    $CLOUDBUILD_SERV_ACC
4.- Authenticate to your GitHub repository using an ADMIN account (see section 4.8.3
    of the playbook). GCP console URL:
    https://console.cloud.google.com/cloud-build/triggers?project=$PROJECT
EOF


