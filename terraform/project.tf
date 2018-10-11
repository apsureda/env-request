resource "random_id" "infrastructure_id" {
  byte_length = 2
}

resource "google_project" "infrastructure" {
  name                = "${var.gcp_project_name}"
  folder_id           = "${var.gcp_folder_id}"
  billing_account     = "${var.gcp_billing_account_id}"
  project_id          = "${var.gcp_project_name}-${random_id.infrastructure_id.hex}"
  auto_create_network = false
}
