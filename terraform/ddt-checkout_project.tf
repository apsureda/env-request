

resource "random_id" "ddt-checkout-dev_id" {
  byte_length = 2
}

resource "google_project" "ddt-checkout-dev" {
  name                = "dft-ddt-checkout"
  folder_id           = "121046915312"
  billing_account     = "${var.gcp_billing_account_id}"
  project_id          = "dft-ddt-checkout-${random_id.ddt-checkout-dev_id.hex}"
}

resource "google_app_engine_application" "ddt-checkout-dev_app" {
  project = "${google_project.ddt-checkout-dev.project_id}"
  location_id = "${var.gcp_region}"
}
resource "random_id" "ddt-checkout-test_id" {
  byte_length = 2
}

resource "google_project" "ddt-checkout-test" {
  name                = "dft-ddt-checkout"
  folder_id           = "121046915312"
  billing_account     = "${var.gcp_billing_account_id}"
  project_id          = "dft-ddt-checkout-${random_id.ddt-checkout-test_id.hex}"
}

resource "google_app_engine_application" "ddt-checkout-test_app" {
  project = "${google_project.ddt-checkout-test.project_id}"
  location_id = "${var.gcp_region}"
}
resource "random_id" "ddt-checkout-prod_id" {
  byte_length = 2
}

resource "google_project" "ddt-checkout-prod" {
  name                = "dft-ddt-checkout"
  folder_id           = "121046915312"
  billing_account     = "${var.gcp_billing_account_id}"
  project_id          = "dft-ddt-checkout-${random_id.ddt-checkout-prod_id.hex}"
}

resource "google_app_engine_application" "ddt-checkout-prod_app" {
  project = "${google_project.ddt-checkout-prod.project_id}"
  location_id = "${var.gcp_region}"
}