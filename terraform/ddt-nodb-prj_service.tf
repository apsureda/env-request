


resource "google_project_service" "ddt-nodb-prj-dev_appengine" {
  project            = "${google_project.ddt-nodb-prj-dev.project_id}"
  service            = "appengine.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-nodb-prj-dev_sql-component" {
  project            = "${google_project.ddt-nodb-prj-dev.project_id}"
  service            = "sql-component.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-nodb-prj-dev_storage-api" {
  project            = "${google_project.ddt-nodb-prj-dev.project_id}"
  service            = "storage-api.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-nodb-prj-dev_storage-component" {
  project            = "${google_project.ddt-nodb-prj-dev.project_id}"
  service            = "storage-component.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-nodb-prj-dev_cloudkms" {
  project            = "${google_project.ddt-nodb-prj-dev.project_id}"
  service            = "cloudkms.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-nodb-prj-dev_cloudbuild" {
  project            = "${google_project.ddt-nodb-prj-dev.project_id}"
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-nodb-prj-dev_iap" {
  project            = "${google_project.ddt-nodb-prj-dev.project_id}"
  service            = "iap.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-nodb-prj-dev_sourcerepo" {
  project            = "${google_project.ddt-nodb-prj-dev.project_id}"
  service            = "sourcerepo.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "ddt-nodb-prj-test_appengine" {
  project            = "${google_project.ddt-nodb-prj-test.project_id}"
  service            = "appengine.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-nodb-prj-test_sql-component" {
  project            = "${google_project.ddt-nodb-prj-test.project_id}"
  service            = "sql-component.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-nodb-prj-test_storage-api" {
  project            = "${google_project.ddt-nodb-prj-test.project_id}"
  service            = "storage-api.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-nodb-prj-test_storage-component" {
  project            = "${google_project.ddt-nodb-prj-test.project_id}"
  service            = "storage-component.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-nodb-prj-test_cloudkms" {
  project            = "${google_project.ddt-nodb-prj-test.project_id}"
  service            = "cloudkms.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-nodb-prj-test_cloudbuild" {
  project            = "${google_project.ddt-nodb-prj-test.project_id}"
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-nodb-prj-test_iap" {
  project            = "${google_project.ddt-nodb-prj-test.project_id}"
  service            = "iap.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-nodb-prj-test_sourcerepo" {
  project            = "${google_project.ddt-nodb-prj-test.project_id}"
  service            = "sourcerepo.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "ddt-nodb-prj-prod_appengine" {
  project            = "${google_project.ddt-nodb-prj-prod.project_id}"
  service            = "appengine.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-nodb-prj-prod_sql-component" {
  project            = "${google_project.ddt-nodb-prj-prod.project_id}"
  service            = "sql-component.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-nodb-prj-prod_storage-api" {
  project            = "${google_project.ddt-nodb-prj-prod.project_id}"
  service            = "storage-api.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-nodb-prj-prod_storage-component" {
  project            = "${google_project.ddt-nodb-prj-prod.project_id}"
  service            = "storage-component.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-nodb-prj-prod_cloudkms" {
  project            = "${google_project.ddt-nodb-prj-prod.project_id}"
  service            = "cloudkms.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-nodb-prj-prod_cloudbuild" {
  project            = "${google_project.ddt-nodb-prj-prod.project_id}"
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-nodb-prj-prod_iap" {
  project            = "${google_project.ddt-nodb-prj-prod.project_id}"
  service            = "iap.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-nodb-prj-prod_sourcerepo" {
  project            = "${google_project.ddt-nodb-prj-prod.project_id}"
  service            = "sourcerepo.googleapis.com"
  disable_on_destroy = false
}