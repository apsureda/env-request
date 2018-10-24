
resource "random_id" "ddt-sb-john-doe_id" {
  byte_length = 2
}

resource "google_project" "ddt-sb-john-doe" {
  name                = "dft-ddt-sb-john-doe"
  folder_id           = "121046915312"
  billing_account     = "${var.gcp_billing_account_id}"
  project_id          = "dft-ddt-sb-john-doe-${random_id.ddt-sb-john-doe_id.hex}"
}

resource "google_app_engine_application" "ddt-sb-john-doe_app" {
  project     = "${google_project.ddt-sb-john-doe.project_id}"
  location_id = "${var.gcp_region}"
}