

resource "google_project_service" "ddt-sb-jane-doe_appengine" {
  project            = "${google_project.ddt-sb-jane-doe.project_id}"
  service            = "appengine.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-sb-jane-doe_sql-component" {
  project            = "${google_project.ddt-sb-jane-doe.project_id}"
  service            = "sql-component.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-sb-jane-doe_storage-api" {
  project            = "${google_project.ddt-sb-jane-doe.project_id}"
  service            = "storage-api.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-sb-jane-doe_storage-component" {
  project            = "${google_project.ddt-sb-jane-doe.project_id}"
  service            = "storage-component.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-sb-jane-doe_cloudkms" {
  project            = "${google_project.ddt-sb-jane-doe.project_id}"
  service            = "cloudkms.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-sb-jane-doe_cloudbuild" {
  project            = "${google_project.ddt-sb-jane-doe.project_id}"
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-sb-jane-doe_iap" {
  project            = "${google_project.ddt-sb-jane-doe.project_id}"
  service            = "iap.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-sb-jane-doe_sourcerepo" {
  project            = "${google_project.ddt-sb-jane-doe.project_id}"
  service            = "sourcerepo.googleapis.com"
  disable_on_destroy = false
}