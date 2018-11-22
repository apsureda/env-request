


resource "google_project_service" "ddt-checkout-dev_appengine" {
  project            = "${google_project.ddt-checkout-dev.project_id}"
  service            = "appengine.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-checkout-dev_sql-component" {
  project            = "${google_project.ddt-checkout-dev.project_id}"
  service            = "sql-component.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-checkout-dev_storage-api" {
  project            = "${google_project.ddt-checkout-dev.project_id}"
  service            = "storage-api.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-checkout-dev_storage-component" {
  project            = "${google_project.ddt-checkout-dev.project_id}"
  service            = "storage-component.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-checkout-dev_cloudkms" {
  project            = "${google_project.ddt-checkout-dev.project_id}"
  service            = "cloudkms.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-checkout-dev_cloudbuild" {
  project            = "${google_project.ddt-checkout-dev.project_id}"
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-checkout-dev_iap" {
  project            = "${google_project.ddt-checkout-dev.project_id}"
  service            = "iap.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-checkout-dev_sourcerepo" {
  project            = "${google_project.ddt-checkout-dev.project_id}"
  service            = "sourcerepo.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "ddt-checkout-test_appengine" {
  project            = "${google_project.ddt-checkout-test.project_id}"
  service            = "appengine.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-checkout-test_sql-component" {
  project            = "${google_project.ddt-checkout-test.project_id}"
  service            = "sql-component.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-checkout-test_storage-api" {
  project            = "${google_project.ddt-checkout-test.project_id}"
  service            = "storage-api.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-checkout-test_storage-component" {
  project            = "${google_project.ddt-checkout-test.project_id}"
  service            = "storage-component.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-checkout-test_cloudkms" {
  project            = "${google_project.ddt-checkout-test.project_id}"
  service            = "cloudkms.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-checkout-test_cloudbuild" {
  project            = "${google_project.ddt-checkout-test.project_id}"
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-checkout-test_iap" {
  project            = "${google_project.ddt-checkout-test.project_id}"
  service            = "iap.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-checkout-test_sourcerepo" {
  project            = "${google_project.ddt-checkout-test.project_id}"
  service            = "sourcerepo.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "ddt-checkout-prod_appengine" {
  project            = "${google_project.ddt-checkout-prod.project_id}"
  service            = "appengine.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-checkout-prod_sql-component" {
  project            = "${google_project.ddt-checkout-prod.project_id}"
  service            = "sql-component.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-checkout-prod_storage-api" {
  project            = "${google_project.ddt-checkout-prod.project_id}"
  service            = "storage-api.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-checkout-prod_storage-component" {
  project            = "${google_project.ddt-checkout-prod.project_id}"
  service            = "storage-component.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-checkout-prod_cloudkms" {
  project            = "${google_project.ddt-checkout-prod.project_id}"
  service            = "cloudkms.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-checkout-prod_cloudbuild" {
  project            = "${google_project.ddt-checkout-prod.project_id}"
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-checkout-prod_iap" {
  project            = "${google_project.ddt-checkout-prod.project_id}"
  service            = "iap.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-checkout-prod_sourcerepo" {
  project            = "${google_project.ddt-checkout-prod.project_id}"
  service            = "sourcerepo.googleapis.com"
  disable_on_destroy = false
}