

resource "google_kms_key_ring" "ddt-nodb-prj-dev" {
  name     = "CLOUDBUILD-SECRETS"
  project  = "${google_project.ddt-nodb-prj-dev.project_id}"
  location = "${var.gcp_region}"
  # wait for the cloudkms API to be activated before creating the keyring
  depends_on = [ "google_project_service.ddt-nodb-prj-dev_cloudkms" ]
}

resource "google_kms_crypto_key" "ddt-nodb-prj-dev" {
  name     = "CLOUDBUILD-KEY"
  key_ring = "${google_kms_key_ring.ddt-nodb-prj-dev.id}"
}

# only the build pipeline can decrypt data using this key
resource "google_kms_crypto_key_iam_binding" "ddt-nodb-prj-dev_decrypters" {
  depends_on = [ "google_kms_crypto_key.ddt-nodb-prj-dev" ]
  crypto_key_id = "${google_project.ddt-nodb-prj-dev.project_id}/${var.gcp_region}/CLOUDBUILD-SECRETS/CLOUDBUILD-KEY"
  role          = "roles/cloudkms.cryptoKeyDecrypter"

  members = [
    "serviceAccount:${google_project.ddt-nodb-prj-dev.number}@cloudbuild.gserviceaccount.com",
  ]
}

# most teams can encrypt data using this key using the following gcloud command:
# gcloud kms encrypt --plaintext-file=secrets.sh \
#     --ciphertext-file=secrets-development.sh.enc --location=[REGION] \
#     --keyring=CLOUDBUILD-SECRETS --key=CLOUDBUILD-KEY --project=[PROJECT_ID]
resource "google_kms_crypto_key_iam_binding" "ddt-nodb-prj-dev_encrypters" {
  depends_on = [ "google_kms_crypto_key.ddt-nodb-prj-dev" ]
  crypto_key_id = "${google_project.ddt-nodb-prj-dev.project_id}/${var.gcp_region}/CLOUDBUILD-SECRETS/CLOUDBUILD-KEY"
  role          = "roles/cloudkms.cryptoKeyEncrypter"

  members = [
        "group:gcp-ddt-mamagers@apszaz.com",
        "group:gcp-ddt-developers@apszaz.com",
        "group:gcp-ddt-ops@apszaz.com",
      ]
}
resource "google_kms_key_ring" "ddt-nodb-prj-test" {
  name     = "CLOUDBUILD-SECRETS"
  project  = "${google_project.ddt-nodb-prj-test.project_id}"
  location = "${var.gcp_region}"
  # wait for the cloudkms API to be activated before creating the keyring
  depends_on = [ "google_project_service.ddt-nodb-prj-test_cloudkms" ]
}

resource "google_kms_crypto_key" "ddt-nodb-prj-test" {
  name     = "CLOUDBUILD-KEY"
  key_ring = "${google_kms_key_ring.ddt-nodb-prj-test.id}"
}

# only the build pipeline can decrypt data using this key
resource "google_kms_crypto_key_iam_binding" "ddt-nodb-prj-test_decrypters" {
  depends_on = [ "google_kms_crypto_key.ddt-nodb-prj-test" ]
  crypto_key_id = "${google_project.ddt-nodb-prj-test.project_id}/${var.gcp_region}/CLOUDBUILD-SECRETS/CLOUDBUILD-KEY"
  role          = "roles/cloudkms.cryptoKeyDecrypter"

  members = [
    "serviceAccount:${google_project.ddt-nodb-prj-test.number}@cloudbuild.gserviceaccount.com",
  ]
}

# most teams can encrypt data using this key using the following gcloud command:
# gcloud kms encrypt --plaintext-file=secrets.sh \
#     --ciphertext-file=secrets-development.sh.enc --location=[REGION] \
#     --keyring=CLOUDBUILD-SECRETS --key=CLOUDBUILD-KEY --project=[PROJECT_ID]
resource "google_kms_crypto_key_iam_binding" "ddt-nodb-prj-test_encrypters" {
  depends_on = [ "google_kms_crypto_key.ddt-nodb-prj-test" ]
  crypto_key_id = "${google_project.ddt-nodb-prj-test.project_id}/${var.gcp_region}/CLOUDBUILD-SECRETS/CLOUDBUILD-KEY"
  role          = "roles/cloudkms.cryptoKeyEncrypter"

  members = [
        "group:gcp-ddt-mamagers@apszaz.com",
        "group:gcp-ddt-developers@apszaz.com",
        "group:gcp-ddt-ops@apszaz.com",
      ]
}
resource "google_kms_key_ring" "ddt-nodb-prj-prod" {
  name     = "CLOUDBUILD-SECRETS"
  project  = "${google_project.ddt-nodb-prj-prod.project_id}"
  location = "${var.gcp_region}"
  # wait for the cloudkms API to be activated before creating the keyring
  depends_on = [ "google_project_service.ddt-nodb-prj-prod_cloudkms" ]
}

resource "google_kms_crypto_key" "ddt-nodb-prj-prod" {
  name     = "CLOUDBUILD-KEY"
  key_ring = "${google_kms_key_ring.ddt-nodb-prj-prod.id}"
}

# only the build pipeline can decrypt data using this key
resource "google_kms_crypto_key_iam_binding" "ddt-nodb-prj-prod_decrypters" {
  depends_on = [ "google_kms_crypto_key.ddt-nodb-prj-prod" ]
  crypto_key_id = "${google_project.ddt-nodb-prj-prod.project_id}/${var.gcp_region}/CLOUDBUILD-SECRETS/CLOUDBUILD-KEY"
  role          = "roles/cloudkms.cryptoKeyDecrypter"

  members = [
    "serviceAccount:${google_project.ddt-nodb-prj-prod.number}@cloudbuild.gserviceaccount.com",
  ]
}

# most teams can encrypt data using this key using the following gcloud command:
# gcloud kms encrypt --plaintext-file=secrets.sh \
#     --ciphertext-file=secrets-development.sh.enc --location=[REGION] \
#     --keyring=CLOUDBUILD-SECRETS --key=CLOUDBUILD-KEY --project=[PROJECT_ID]
resource "google_kms_crypto_key_iam_binding" "ddt-nodb-prj-prod_encrypters" {
  depends_on = [ "google_kms_crypto_key.ddt-nodb-prj-prod" ]
  crypto_key_id = "${google_project.ddt-nodb-prj-prod.project_id}/${var.gcp_region}/CLOUDBUILD-SECRETS/CLOUDBUILD-KEY"
  role          = "roles/cloudkms.cryptoKeyEncrypter"

  members = [
        "group:gcp-ddt-mamagers@apszaz.com",
        "group:gcp-ddt-developers@apszaz.com",
        "group:gcp-ddt-ops@apszaz.com",
      ]
}