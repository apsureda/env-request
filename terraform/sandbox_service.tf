

resource "google_project_service" "ddt-sb-johndoe_appengine" {
  project            = "${google_project.ddt-sb-johndoe.project_id}"
  service            = "appengine.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-sb-johndoe_sql-component" {
  project            = "${google_project.ddt-sb-johndoe.project_id}"
  service            = "sql-component.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-sb-johndoe_storage-api" {
  project            = "${google_project.ddt-sb-johndoe.project_id}"
  service            = "storage-api.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-sb-johndoe_storage-component" {
  project            = "${google_project.ddt-sb-johndoe.project_id}"
  service            = "storage-component.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-sb-johndoe_cloudkms" {
  project            = "${google_project.ddt-sb-johndoe.project_id}"
  service            = "cloudkms.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-sb-johndoe_cloudbuild" {
  project            = "${google_project.ddt-sb-johndoe.project_id}"
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-sb-johndoe_iap" {
  project            = "${google_project.ddt-sb-johndoe.project_id}"
  service            = "iap.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "ddt-sb-johndoe_sourcerepo" {
  project            = "${google_project.ddt-sb-johndoe.project_id}"
  service            = "sourcerepo.googleapis.com"
  disable_on_destroy = false
}