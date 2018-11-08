# add a random 4 hex char suffix to the project ID, so we can destry/apply this
# terraform file without running into project ID reuse conflicts.
resource "random_id" "ddt-db-app-data_id" {
  byte_length = 2
}

resource "google_project" "ddt-db-app-data" {
  name            = "dft-ddt-db-app-data"
  folder_id       = "${google_folder.DFT-ORG_DATABASES.id}"
  billing_account = "${var.gcp_billing_account_id}"
  project_id      = "dft-ddt-db-app-data-${random_id.ddt-db-app-data_id.hex}"
}