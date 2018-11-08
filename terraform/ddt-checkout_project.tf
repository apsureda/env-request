# add a random 4 hex char suffix to the project ID, so we can destry/apply this
# terraform file without running into project ID reuse conflicts.
resource "random_id" "ddt-checkout-dev_id" {
  byte_length = 2
}

resource "google_project" "ddt-checkout-dev" {
  name            = "dft-ddt-checkout-dev"
  folder_id       = "${google_folder.DFT-ORG_DDT.id}"
  billing_account = "${var.gcp_billing_account_id}"
  project_id      = "dft-ddt-checkout-dev-${random_id.ddt-checkout-dev_id.hex}"
}

resource "google_app_engine_application" "ddt-checkout-dev_app" {
  project = "${google_project.ddt-checkout-dev.project_id}"
  location_id = "${var.gcp_region}"
}# add a random 4 hex char suffix to the project ID, so we can destry/apply this
# terraform file without running into project ID reuse conflicts.
resource "random_id" "ddt-checkout-test_id" {
  byte_length = 2
}

resource "google_project" "ddt-checkout-test" {
  name            = "dft-ddt-checkout-test"
  folder_id       = "${google_folder.DFT-ORG_DDT.id}"
  billing_account = "${var.gcp_billing_account_id}"
  project_id      = "dft-ddt-checkout-test-${random_id.ddt-checkout-test_id.hex}"
}

resource "google_app_engine_application" "ddt-checkout-test_app" {
  project = "${google_project.ddt-checkout-test.project_id}"
  location_id = "${var.gcp_region}"
}# add a random 4 hex char suffix to the project ID, so we can destry/apply this
# terraform file without running into project ID reuse conflicts.
resource "random_id" "ddt-checkout-prod_id" {
  byte_length = 2
}

resource "google_project" "ddt-checkout-prod" {
  name            = "dft-ddt-checkout-prod"
  folder_id       = "${google_folder.DFT-ORG_DDT.id}"
  billing_account = "${var.gcp_billing_account_id}"
  project_id      = "dft-ddt-checkout-prod-${random_id.ddt-checkout-prod_id.hex}"
}

resource "google_app_engine_application" "ddt-checkout-prod_app" {
  project = "${google_project.ddt-checkout-prod.project_id}"
  location_id = "${var.gcp_region}"
}