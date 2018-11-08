# add a random 4 hex char suffix to the project ID, so we can destry/apply this
# terraform file without running into project ID reuse conflicts.
resource "random_id" "ddt-nodb-prj-dev_id" {
  byte_length = 2
}

resource "google_project" "ddt-nodb-prj-dev" {
  name            = "dft-ddt-nodb-prj-dev"
  folder_id       = "${google_folder.DFT-ORG_DDT.id}"
  billing_account = "${var.gcp_billing_account_id}"
  project_id      = "dft-ddt-nodb-prj-dev-${random_id.ddt-nodb-prj-dev_id.hex}"
}

resource "google_app_engine_application" "ddt-nodb-prj-dev_app" {
  project = "${google_project.ddt-nodb-prj-dev.project_id}"
  location_id = "${var.gcp_region}"
}# add a random 4 hex char suffix to the project ID, so we can destry/apply this
# terraform file without running into project ID reuse conflicts.
resource "random_id" "ddt-nodb-prj-test_id" {
  byte_length = 2
}

resource "google_project" "ddt-nodb-prj-test" {
  name            = "dft-ddt-nodb-prj-test"
  folder_id       = "${google_folder.DFT-ORG_DDT.id}"
  billing_account = "${var.gcp_billing_account_id}"
  project_id      = "dft-ddt-nodb-prj-test-${random_id.ddt-nodb-prj-test_id.hex}"
}

resource "google_app_engine_application" "ddt-nodb-prj-test_app" {
  project = "${google_project.ddt-nodb-prj-test.project_id}"
  location_id = "${var.gcp_region}"
}# add a random 4 hex char suffix to the project ID, so we can destry/apply this
# terraform file without running into project ID reuse conflicts.
resource "random_id" "ddt-nodb-prj-prod_id" {
  byte_length = 2
}

resource "google_project" "ddt-nodb-prj-prod" {
  name            = "dft-ddt-nodb-prj-prod"
  folder_id       = "${google_folder.DFT-ORG_DDT.id}"
  billing_account = "${var.gcp_billing_account_id}"
  project_id      = "dft-ddt-nodb-prj-prod-${random_id.ddt-nodb-prj-prod_id.hex}"
}

resource "google_app_engine_application" "ddt-nodb-prj-prod_app" {
  project = "${google_project.ddt-nodb-prj-prod.project_id}"
  location_id = "${var.gcp_region}"
}