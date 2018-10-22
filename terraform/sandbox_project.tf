
resource "random_id" "ddt-sb-john-doe2_id" {
  byte_length = 2
}

resource "google_project" "ddt-sb-john-doe2" {
  name                = "dft-ddt-sb-john-doe2"
  folder_id           = ""
  billing_account     = "${var.gcp_billing_account_id}"
  project_id          = "dft-ddt-sb-john-doe2-${random_id.ddt-sb-john-doe2_id.hex}"
}

resource "google_app_engine_application" "ddt-sb-john-doe2_app" {
  project     = "${google_project.ddt-sb-john-doe2.project_id}"
  location_id = "${var.gcp_region}"
}