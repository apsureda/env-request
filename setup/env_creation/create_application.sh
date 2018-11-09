#!/bin/bash -x

DFT_APP_NAME="checkin3"
DFT_BU="ddt"
PROJECT_PREFIX="dft-${DFT_BU}-${DFT_APP_NAME}"
FOLDER="722317743512"
BILLING_ACCOUNT="0131D6-94FD9F-065EAB"
REGION="europe-west2"
# set to yes if using Google App Engine Flex
GAE_FLEX="no"

# team names
TEAM_DEV="gcp-ddt-developers@apszaz.com" # dft.gov.uk
TEAM_OPS="gcp-ddt-ops@apszaz.com"
TEAM_QA="gcp-ddt-qa@apszaz.com"
TEAM_MNG="gcp-ddt-mamagers@apszaz.com"
TEAM_CICD="gcp-global-cicd@apszaz.com"

for env in "dev" "test" "prod"; do
  PROJECT=$PROJECT_PREFIX-$env
  # create the project and enable billing
  gcloud projects create "$PROJECT" --folder=$FOLDER
  gcloud beta billing projects link $PROJECT --billing-account=$BILLING_ACCOUNT
  
  # GAE service type
  GAE_SERVICE="appengine.googleapis.com"
  if [ "$GAE_FLEX" == "yes" ]; then
    GAE_SERVICE="appengineflex.googleapis.com"
  fi

  # GCP services required by this application (GAE flex is appengineflex.googleapis.com)
  GCP_SERVICES="$GAE_SERVICE \
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
  
  # create the App Engine app
  gcloud app create --region=$REGION --project=$PROJECT
  
  # see what App Engine permissions we have available
  #gcloud iam list-grantable-roles //cloudresourcemanager.googleapis.com/projects/${PROJECT_PREFIX}-$ENVIRONMENT --filter="(title~'Engine')"
done


# DEV environment
PROJECT=$PROJECT_PREFIX-dev
PROJECT_NUMBER=$(gcloud projects describe $PROJECT --format="value(projectNumber)")
CLOUDBUILD_SERV_ACC="${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com"
gcloud projects add-iam-policy-binding $PROJECT --member=group:$TEAM_DEV --role=roles/appengine.deployer
gcloud projects add-iam-policy-binding $PROJECT --member=group:$TEAM_DEV --role=roles/appengine.serviceAdmin
gcloud projects add-iam-policy-binding $PROJECT --member=group:$TEAM_OPS --role=roles/appengine.appAdmin
gcloud projects add-iam-policy-binding $PROJECT --member=group:$TEAM_MNG --role=roles/appengine.appAdmin
gcloud projects add-iam-policy-binding $PROJECT --member=serviceAccount:$CLOUDBUILD_SERV_ACC --role=roles/appengine.appAdmin

# TEST environmentPROJECT
PROJECT=$PROJECT_PREFIX-test
PROJECT_NUMBER=$(gcloud projects describe $PROJECT --format="value(projectNumber)")
CLOUDBUILD_SERV_ACC="${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com"
gcloud projects add-iam-policy-binding $PROJECT --member=group:$TEAM_DEV --role=roles/appengine.codeViewer
gcloud projects add-iam-policy-binding $PROJECT --member=group:$TEAM_OPS --role=roles/appengine.serviceAdmin
gcloud projects add-iam-policy-binding $PROJECT --member=group:$TEAM_QA --role=roles/appengine.codeViewer
gcloud projects add-iam-policy-binding $PROJECT --member=group:$TEAM_MNG --role=roles/appengine.appViewer
gcloud projects add-iam-policy-binding $PROJECT --member=serviceAccount:$CLOUDBUILD_SERV_ACC --role=roles/appengine.appAdmin

# PROD environmentPROJECT
PROJECT=$PROJECT_PREFIX-prod
PROJECT_NUMBER=$(gcloud projects describe $PROJECT --format="value(projectNumber)")
CLOUDBUILD_SERV_ACC="${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com"
gcloud projects add-iam-policy-binding $PROJECT --member=group:$TEAM_DEV --role=roles/appengine.codeViewer
gcloud projects add-iam-policy-binding $PROJECT --member=group:$TEAM_OPS --role=roles/appengine.serviceAdmin
gcloud projects add-iam-policy-binding $PROJECT --member=group:$TEAM_QA --role=roles/appengine.codeViewer
gcloud projects add-iam-policy-binding $PROJECT --member=group:$TEAM_MNG --role=roles/appengine.appViewer
gcloud projects add-iam-policy-binding $PROJECT --member=serviceAccount:$CLOUDBUILD_SERV_ACC --role=roles/appengine.appAdmin

# Configure firewall rules
# CIDR ranges for internal testing and prod
SOURCE_ADDR_DEV="" #"104.132.117.68"
SOURCE_ADDR_TEST=$SOURCE_ADDR_DEV
SOURCE_ADDR_PROD="" # "104.132.117.0/24"

if [ "$SOURCE_ADDR_DEV" != "" ]; then
  PROJECT=$PROJECT_PREFIX-dev
  gcloud app firewall-rules create 1000 --source-range=$SOURCE_ADDR_DEV --action=allow --project=$PROJECT
  gcloud app firewall-rules update 2147483647 --action=deny --project=$PROJECT # default rule: deny access
fi
if [ "$SOURCE_ADDR_TEST" != "" ]; then
  PROJECT=$PROJECT_PREFIX-test
  gcloud app firewall-rules create 1000 --source-range=$SOURCE_ADDR_TEST --action=allow --project=$PROJECT
  gcloud app firewall-rules update 2147483647 --action=deny --project=$PROJECT # default rule: deny access
fi
if [ "$SOURCE_ADDR_PROD" != "" ]; then
  PROJECT=$PROJECT_PREFIX-prod
  gcloud app firewall-rules create 1000 --source-range=$SOURCE_ADDR_PROD --action=allow --project=$PROJECT
  gcloud app firewall-rules update 2147483647 --action=deny --project=$SOURCE_ADDR_PROD # default rule: deny access
fi

# test firewall rules
#gcloud app firewall-rules test-ip "104.132.117.69/32" --project=${PROJECT_PREFIX}-dev


# Cloud SQL
CLOUD_SQL_PROJECT_NONPROD="apszaz-dft-mt3-nonprod"
CLOUD_SQL_INSTANCE_NONPROD="ddt-nonprod"
CLOUD_SQL_INSTANCE_NONPROD_PWD="mypasswd"

CLOUD_SQL_PROJECT_PROD="apszaz-dft-mt3-prod"
CLOUD_SQL_INSTANCE_PROD="ddt-prod"
CLOUD_SQL_INSTANCE_PROD_PWD="mypasswd"


# Create the DB projects, if they do not already exist
for proj in $CLOUD_SQL_PROJECT_NONPROD $CLOUD_SQL_PROJECT_PROD; do
  # check if the project has already been created
  proj_number=$(gcloud projects describe $proj --format="value(projectNumber)" 2>/dev/null || echo "undefined")
  if [ "$proj_number" = "undefined" ]; then
    gcloud projects create "$proj" --folder=$FOLDER
    gcloud beta billing projects link $proj --billing-account=$BILLING_ACCOUNT
    gcloud services enable sql-component.googleapis.com --project=$proj
  fi
done


create_db_instance() {
  project_code=$1
  region=$2
  instance_name=$3
  dbpasswd=$4
  # create the DB instance if it doesn't already exist
  CONNECTIONNAME=$(gcloud sql instances describe $instance_name --project=$project_code --format="value(connectionName)" 2>/dev/null || echo "undefined")
  if [ "$CONNECTIONNAME" == "undefined" ]; then
    gcloud sql instances create $instance_name --region=$region --project=$project_code
    gcloud sql users set-password root --host=% --instance=$instance_name --password=$dbpasswd --project=$project_code
    CONNECTIONNAME=$(gcloud sql instances describe $instance_name --project=$project_code --format="value(connectionName)"  || echo "undefined")
    echo "Cloud SQL instance created. Connection name: $CONNECTIONNAME_NONPROD"
  fi
}

create_db() {
  project_code=$1
  instance_name=$2
  dbname=$3
  appname=$4
  createdname=$(gcloud sql databases describe $dbname --instance=$instance_name --project=$project_code --format="value(name)" 2>/dev/null)
  if [ "$dbname" != "$createdname" ]; then
    gcloud sql databases create $dbname --instance=$instance_name --project=$project_code
    gcloud projects add-iam-policy-binding $project_code --member=serviceAccount:${appname}@appspot.gserviceaccount.com --role=roles/cloudsql.client
  fi
}


CREATE_DBS="yes"
if [ "$CREATE_DBS" == "yes" ]; then
  # create non prod databases
  create_db_instance $CLOUD_SQL_PROJECT_NONPROD $REGION $CLOUD_SQL_INSTANCE_NONPROD $CLOUD_SQL_INSTANCE_NONPROD_PWD
  create_db $CLOUD_SQL_PROJECT_NONPROD $CLOUD_SQL_INSTANCE_NONPROD ${PROJECT_PREFIX}-dev ${PROJECT_PREFIX}-dev
  create_db $CLOUD_SQL_PROJECT_NONPROD $CLOUD_SQL_INSTANCE_NONPROD ${PROJECT_PREFIX}-test ${PROJECT_PREFIX}-test
  
  # create prod databases
  create_db_instance $CLOUD_SQL_PROJECT_PROD $REGION $CLOUD_SQL_INSTANCE_PROD $CLOUD_SQL_INSTANCE_PROD_PWD
  create_db $CLOUD_SQL_PROJECT_PROD $CLOUD_SQL_INSTANCE_PROD ${PROJECT_PREFIX}-prod ${PROJECT_PREFIX}-prod
fi

create_build_trigger() {
  PROJECT=$1
  ENVIRONMENT=$2
  REPONAME=$3
  BRANCH=$4
  CONNECTION_STRING=$5
  BODY=$(cat <<EOF
  {
    "triggerTemplate": {
      "projectId": "$PROJECT",
      "repoName": "$REPONAME",
      "branchName": "$BRANCH"
    },
    "description": "Push to $BRANCH",
    "filename": "cloudbuild.yaml",
    "substitutions": {
      "_DB_CONNECTION_STR": "$CONNECTION_STRING"
      "_ENV_NAME": "$CONNECTION_STRING"
    }
  }
EOF
)
  curl -X POST -H "Content-Type: application/json" \
  -d "$BODY" \
  https://cloudbuild.googleapis.com/v1/projects/$PROJECT/triggers?\
access_token=$(gcloud auth application-default print-access-token)
}

GH_REPO="github-apsureda-gae-std"
DB_CONNECTION_STR="mysql:dbname=${PROJECT_PREFIX}-dev;unix_socket=/cloudsql/$CLOUD_SQL_PROJECT_NONPROD:$REGION:$CLOUD_SQL_INSTANCE_NONPROD"
create_build_trigger ${PROJECT_PREFIX}-dev dev $GH_REPO development $DB_CONNECTION_STR
DB_CONNECTION_STR="mysql:dbname=${PROJECT_PREFIX}-test;unix_socket=/cloudsql/$CLOUD_SQL_PROJECT_NONPROD:$REGION:$CLOUD_SQL_INSTANCE_NONPROD"
create_build_trigger ${PROJECT_PREFIX}-test test $GH_REPO test $DB_CONNECTION_STR
DB_CONNECTION_STR="mysql:dbname=${PROJECT_PREFIX}-prod;unix_socket=/cloudsql/$CLOUD_SQL_PROJECT_PROD:$REGION:$CLOUD_SQL_INSTANCE_PROD"
create_build_trigger ${PROJECT_PREFIX}-prod prod $GH_REPO master $DB_CONNECTION_STR

# Managing secrets in Cloud KMS
for env in "dev" "test" "prod"; do
  PROJECT=${PROJECT_PREFIX}-$env

  # Create a keyring 
  gcloud kms keyrings create CLOUDBUILD-SECRETS --location=global --project=$PROJECT

  # Create a crypoKey. It will be used later for encrypting secrets.
  gcloud kms keys create CLOUDBUILD-KEY --location=global --keyring=CLOUDBUILD-SECRETS \
    --purpose=encryption --project=$PROJECT
  
  # give decrypt rights to the cloud build pipeline
  PROJECT_NUMBER=$(gcloud projects describe $PROJECT --format="value(projectNumber)")
  CLOUDBUILD_SERV_ACC="${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com"
  gcloud kms keys add-iam-policy-binding CLOUDBUILD-KEY --location=global \
    --keyring=CLOUDBUILD-SECRETS --member=serviceAccount:$CLOUDBUILD_SERV_ACC
    --role=roles/cloudkms.cryptoKeyDecrypter  --project=$PROJECT
done

for env in "dev" "test" "prod"; do
  gcloud kms encrypt --plaintext-file=../secrets.sh --ciphertext-file=secrets-${env}.sh.enc \
    --location=global --keyring=CLOUDBUILD-SECRETS --key=CLOUDBUILD-KEY --project=dft-ddt-checkout-${env}
done

gcloud kms encrypt --plaintext-file=secrets.sh --ciphertext-file=GH_gae-std/secrets-development.sh.enc --location=global --keyring=CLOUDBUILD-SECRETS --key=CLOUDBUILD-KEY --project=$PROJECT




set_iam_policy() {
  project=$1
  allowed_groups=$2
  project_number=$(gcloud projects describe $project --format="value(projectNumber)")
  
  # Format the group email addresses
  members=""
  for m in $allowed_groups; do
    if [ "$members" != "" ]; then
     members="${members},"
    fi
    members="${members} \"group:$m\""
  done
  
  BODY=$(cat <<EOF
{
  "policy" : {
    "bindings": [
      {
        "role": "roles/iap.httpsResourceAccessor",
        "members": [
          $members
        ]
      }
    ]
  }
}
EOF
)
  curl -X POST -H "Content-Type: application/json" \
  -d "$BODY" \
  https://iap.googleapis.com/v1beta1/projects/$project_number/iap_web/:setIamPolicy?\
access_token=$(gcloud auth application-default print-access-token)
}

set_iam_policy dft-ddt-checkout-dev "gcp-ddt-developers@apszaz.com gcp-ddt-ops@apszaz.com"
set_iam_policy dft-ddt-checkout-test "gcp-ddt-developers@apszaz.com gcp-ddt-ops@apszaz.com"
set_iam_policy dft-ddt-checkout-prod "gcp-ddt-developers@apszaz.com gcp-ddt-ops@apszaz.com"


exit



# deploy the app in GAE
gcloud app deploy --project=$PROJECT

# IAP config
# instructions: https://cloud.google.com/iap/docs/app-engine-quickstart
# API: https://cloud.google.com/iap/docs/reference/app-engine-apis
# Challenge: http://screen/8muEwWEfozu.png
# Refused: http://screen/j6JSmLJ3BLE.png

0.- A first version of the app needs to be deployed
1.- Configure OAuth consent screen
2.- 


# Build pipelines
#CICD_PROJECT="apszaz-dft-cicd"

# enable Cloud Build API on CICD project
#gcloud services enable cloudbuild.googleapis.com --project=$CICD_PROJECT
#gcloud services enable appengine.googleapis.com --project=$CICD_PROJECT
#gcloud services enable appengineflex.googleapis.com --project=$CICD_PROJECT
#gcloud services enable cloudkms.googleapis.com --project=$CICD_PROJECT
#gcloud services enable cloudbuilds.builds.create --project=$CICD_PROJECT # cloudbuilds.builds.create needed if using non cloned GitHub repos
# Add the CICD project Service account to the gcp-global-cicd@ group in Cloud Identity. To find the account:
# gcloud projects get-iam-policy $CICD_PROJECT --filter="(bindings.role:roles/cloudbuild)"  --flatten="bindings[].members" --format="value(bindings.members[])"


# grant the Cloud Build viewer role to the Cloud Build Service account. Otherwise, it will not be able to deploy apps to GAE
CLOUD_BUILD_ACCOUNT=$(gcloud projects get-iam-policy ${PROJECT_PREFIX}-dev --filter="(bindings.role:roles/cloudbuild)"  --flatten="bindings[].members" --format="value(bindings.members[])" | grep @cloudbuild | uniq)
gcloud projects add-iam-policy-binding ${PROJECT_PREFIX}-dev --member=$CLOUD_BUILD_ACCOUNT --role=roles/appengine.appAdmin
gcloud projects add-iam-policy-binding ${PROJECT_PREFIX}-dev --member=$CLOUD_BUILD_ACCOUNT --role=roles/storage.admin
gcloud projects add-iam-policy-binding ${PROJECT_PREFIX}-dev --member=$CLOUD_BUILD_ACCOUNT --role=roles/cloudbuild.builds.editor


# push a new version
GIT_TAG=dev-v0.5 ; git tag -a $GIT_TAG -m "Testing build trigger" ; git push google $GIT_TAG





# mapping domains
# see what verified domaions I have
gcloud domains list-user-verified

ORG="apszaz.com"
DNS_BASE_DOMAIN=$ORG
DNS_SUBDOMAIN="teanbiscuits"

gcloud app domain-mappings create ${DNS_SUBDOMAIN}-dev.$DNS_BASE_DOMAIN --project=${PROJECT_PREFIX}-dev # ONLY FOR PROD ??

Created [teanbiscuits-dev.apszaz.com].
Please add the following entries to your domain registrar. DNS changes can require up to 24 hours to take effect.
id: teanbiscuits-dev.apszaz.com
resourceRecords:
- name: teanbiscuits-dev
  rrdata: ghs.googlehosted.com
  type: CNAME

	# see: https://cloud.google.com/appengine/docs/standard/python/mapping-custom-domains
  
  


# cleanup:
# for proj in `gcloud projects list --filter='parent.id:710298211377' --format='value(name)'`; do gcloud projects delete $proj; done

