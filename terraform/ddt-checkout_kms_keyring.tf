

resource "google_kms_key_ring" "ddt-checkout-dev" {
  name     = "CLOUDBUILD-SECRETS"
  project  = "${google_project.ddt-checkout-dev.project_id}"
  location = "${var.gcp_region}"
  # wait for the cloudkms API to be activated before creating the keyring
  depends_on = [ "google_project_service.ddt-checkout-dev_cloudkms" ]
}

resource "google_kms_crypto_key" "ddt-checkout-dev" {
  name     = "CLOUDBUILD-KEY"
  key_ring = "${google_kms_key_ring.ddt-checkout-dev.id}"
}

# only the build pipeline can decrypt data using this key
resource "google_kms_crypto_key_iam_binding" "ddt-checkout-dev_decrypters" {
  depends_on = [ "google_kms_crypto_key.ddt-checkout-dev" ]
  crypto_key_id = "${google_project.ddt-checkout-dev.project_id}/${var.gcp_region}/CLOUDBUILD-SECRETS/CLOUDBUILD-KEY"
  role          = "roles/cloudkms.cryptoKeyDecrypter"

  members = [
    "serviceAccount:${google_project.ddt-checkout-dev.number}@cloudbuild.gserviceaccount.com",
  ]
}

# most teams can encrypt data using this key using the following gcloud command:
# gcloud kms encrypt --plaintext-file=secrets.sh \
#     --ciphertext-file=secrets-development.sh.enc --location=[REGION] \
#     --keyring=CLOUDBUILD-SECRETS --key=CLOUDBUILD-KEY --project=[PROJECT_ID]
resource "google_kms_crypto_key_iam_binding" "ddt-checkout-dev_encrypters" {
  depends_on = [ "google_kms_crypto_key.ddt-checkout-dev" ]
  crypto_key_id = "${google_project.ddt-checkout-dev.project_id}/${var.gcp_region}/CLOUDBUILD-SECRETS/CLOUDBUILD-KEY"
  role          = "roles/cloudkms.cryptoKeyEncrypter"

  members = [
        "group:gcp-ddt-mamagers@apszaz.com",
        "group:gcp-ddt-developers@apszaz.com",
        "group:gcp-ddt-ops@apszaz.com",
      ]
}
resource "google_kms_key_ring" "ddt-checkout-test" {
  name     = "CLOUDBUILD-SECRETS"
  project  = "${google_project.ddt-checkout-test.project_id}"
  location = "${var.gcp_region}"
  # wait for the cloudkms API to be activated before creating the keyring
  depends_on = [ "google_project_service.ddt-checkout-test_cloudkms" ]
}

resource "google_kms_crypto_key" "ddt-checkout-test" {
  name     = "CLOUDBUILD-KEY"
  key_ring = "${google_kms_key_ring.ddt-checkout-test.id}"
}

# only the build pipeline can decrypt data using this key
resource "google_kms_crypto_key_iam_binding" "ddt-checkout-test_decrypters" {
  depends_on = [ "google_kms_crypto_key.ddt-checkout-test" ]
  crypto_key_id = "${google_project.ddt-checkout-test.project_id}/${var.gcp_region}/CLOUDBUILD-SECRETS/CLOUDBUILD-KEY"
  role          = "roles/cloudkms.cryptoKeyDecrypter"

  members = [
    "serviceAccount:${google_project.ddt-checkout-test.number}@cloudbuild.gserviceaccount.com",
  ]
}

# most teams can encrypt data using this key using the following gcloud command:
# gcloud kms encrypt --plaintext-file=secrets.sh \
#     --ciphertext-file=secrets-development.sh.enc --location=[REGION] \
#     --keyring=CLOUDBUILD-SECRETS --key=CLOUDBUILD-KEY --project=[PROJECT_ID]
resource "google_kms_crypto_key_iam_binding" "ddt-checkout-test_encrypters" {
  depends_on = [ "google_kms_crypto_key.ddt-checkout-test" ]
  crypto_key_id = "${google_project.ddt-checkout-test.project_id}/${var.gcp_region}/CLOUDBUILD-SECRETS/CLOUDBUILD-KEY"
  role          = "roles/cloudkms.cryptoKeyEncrypter"

  members = [
        "group:gcp-ddt-mamagers@apszaz.com",
        "group:gcp-ddt-developers@apszaz.com",
        "group:gcp-ddt-ops@apszaz.com",
      ]
}
resource "google_kms_key_ring" "ddt-checkout-prod" {
  name     = "CLOUDBUILD-SECRETS"
  project  = "${google_project.ddt-checkout-prod.project_id}"
  location = "${var.gcp_region}"
  # wait for the cloudkms API to be activated before creating the keyring
  depends_on = [ "google_project_service.ddt-checkout-prod_cloudkms" ]
}

resource "google_kms_crypto_key" "ddt-checkout-prod" {
  name     = "CLOUDBUILD-KEY"
  key_ring = "${google_kms_key_ring.ddt-checkout-prod.id}"
}

# only the build pipeline can decrypt data using this key
resource "google_kms_crypto_key_iam_binding" "ddt-checkout-prod_decrypters" {
  depends_on = [ "google_kms_crypto_key.ddt-checkout-prod" ]
  crypto_key_id = "${google_project.ddt-checkout-prod.project_id}/${var.gcp_region}/CLOUDBUILD-SECRETS/CLOUDBUILD-KEY"
  role          = "roles/cloudkms.cryptoKeyDecrypter"

  members = [
    "serviceAccount:${google_project.ddt-checkout-prod.number}@cloudbuild.gserviceaccount.com",
  ]
}

# most teams can encrypt data using this key using the following gcloud command:
# gcloud kms encrypt --plaintext-file=secrets.sh \
#     --ciphertext-file=secrets-development.sh.enc --location=[REGION] \
#     --keyring=CLOUDBUILD-SECRETS --key=CLOUDBUILD-KEY --project=[PROJECT_ID]
resource "google_kms_crypto_key_iam_binding" "ddt-checkout-prod_encrypters" {
  depends_on = [ "google_kms_crypto_key.ddt-checkout-prod" ]
  crypto_key_id = "${google_project.ddt-checkout-prod.project_id}/${var.gcp_region}/CLOUDBUILD-SECRETS/CLOUDBUILD-KEY"
  role          = "roles/cloudkms.cryptoKeyEncrypter"

  members = [
        "group:gcp-ddt-mamagers@apszaz.com",
        "group:gcp-ddt-developers@apszaz.com",
        "group:gcp-ddt-ops@apszaz.com",
      ]
}