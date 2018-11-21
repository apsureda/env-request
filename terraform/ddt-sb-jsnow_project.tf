# add a random 4 hex char suffix to the project ID, so we can destry/apply this
# terraform file without running into project ID reuse conflicts.
resource "random_id" "ddt-sb-jsnow_id" {
  byte_length = 2
}

resource "google_project" "ddt-sb-jsnow" {
  name            = "dft-ddt-sb-jsnow"
  folder_id       = "${google_folder.DFT-ORG_DDT_SANDBOXES.id}"
  billing_account = "${var.gcp_billing_account_id}"
  project_id      = "dft-ddt-sb-jsnow-${random_id.ddt-sb-jsnow_id.hex}"
}

resource "google_app_engine_application" "ddt-sb-jsnow_app" {
  project     = "${google_project.ddt-sb-jsnow.project_id}"
  location_id = "${var.gcp_region}"
}