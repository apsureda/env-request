
resource "random_id" "ddt-sb-johndoe_id" {
  byte_length = 2
}

resource "google_project" "ddt-sb-johndoe" {
  name                = "dft-ddt-sb-johndoe"
  folder_id           = ""
  billing_account     = "${var.gcp_billing_account_id}"
  project_id          = "dft-ddt-sb-johndoe-${random_id.ddt-sb-johndoe_id.hex}"
}

resource "google_app_engine_application" "ddt-sb-johndoe_app" {
  project     = "${google_project.ddt-sb-johndoe.project_id}"
  location_id = "${var.gcp_region}"
}