
resource "google_project_iam_binding" "ddt-checkout-dev_appengine_serviceAdmin" {
  project = "${google_project.ddt-checkout-dev.project_id}"
  role    = "roles/appengine.serviceAdmin"

  members = [
        "group:gcp-ddt-developers@dft.gov.uk",  ]
}
resource "google_project_iam_binding" "ddt-checkout-dev_appengine_deployer" {
  project = "${google_project.ddt-checkout-dev.project_id}"
  role    = "roles/appengine.deployer"

  members = [
        "group:gcp-ddt-developers@dft.gov.uk",  ]
}
resource "google_project_iam_binding" "ddt-checkout-dev_appengine_appAdmin" {
  project = "${google_project.ddt-checkout-dev.project_id}"
  role    = "roles/appengine.appAdmin"

  members = [
        "group:gcp-ddt-ops@dft.gov.uk",    "group:gcp-ddt-mamagers@dft.gov.uk",    "serviceAccount:${google_project.ddt-checkout-dev.number}@cloudbuild.gserviceaccount.com",  ]
}
resource "google_project_iam_binding" "ddt-checkout-test_appengine_codeViewer" {
  project = "${google_project.ddt-checkout-test.project_id}"
  role    = "roles/appengine.codeViewer"

  members = [
        "group:gcp-ddt-developers@dft.gov.uk",    "group:gcp-ddt-qa@dft.gov.uk",  ]
}
resource "google_project_iam_binding" "ddt-checkout-test_appengine_serviceAdmin" {
  project = "${google_project.ddt-checkout-test.project_id}"
  role    = "roles/appengine.serviceAdmin"

  members = [
        "group:gcp-ddt-ops@dft.gov.uk",  ]
}
resource "google_project_iam_binding" "ddt-checkout-test_appengine_appViewer" {
  project = "${google_project.ddt-checkout-test.project_id}"
  role    = "roles/appengine.appViewer"

  members = [
        "group:gcp-ddt-mamagers@dft.gov.uk",  ]
}
resource "google_project_iam_binding" "ddt-checkout-test_appengine_appAdmin" {
  project = "${google_project.ddt-checkout-test.project_id}"
  role    = "roles/appengine.appAdmin"

  members = [
        "serviceAccount:${google_project.ddt-checkout-test.number}@cloudbuild.gserviceaccount.com",  ]
}
resource "google_project_iam_binding" "ddt-checkout-prod_appengine_codeViewer" {
  project = "${google_project.ddt-checkout-prod.project_id}"
  role    = "roles/appengine.codeViewer"

  members = [
        "group:gcp-ddt-developers@dft.gov.uk",    "group:gcp-ddt-qa@dft.gov.uk",  ]
}
resource "google_project_iam_binding" "ddt-checkout-prod_appengine_serviceAdmin" {
  project = "${google_project.ddt-checkout-prod.project_id}"
  role    = "roles/appengine.serviceAdmin"

  members = [
        "group:gcp-ddt-ops@dft.gov.uk",  ]
}
resource "google_project_iam_binding" "ddt-checkout-prod_appengine_appViewer" {
  project = "${google_project.ddt-checkout-prod.project_id}"
  role    = "roles/appengine.appViewer"

  members = [
        "group:gcp-ddt-mamagers@dft.gov.uk",  ]
}
resource "google_project_iam_binding" "ddt-checkout-prod_appengine_appAdmin" {
  project = "${google_project.ddt-checkout-prod.project_id}"
  role    = "roles/appengine.appAdmin"

  members = [
        "serviceAccount:${google_project.ddt-checkout-prod.number}@cloudbuild.gserviceaccount.com",  ]
}