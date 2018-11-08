
resource "google_project_iam_binding" "ddt-checkout-dev_appengine_serviceAdmin" {
  project = "${google_project.ddt-checkout-dev.project_id}"
  role    = "roles/appengine.serviceAdmin"

  members = [
    "group:gcp-ddt-developers@apszaz.com",
  ]
}


resource "google_project_iam_binding" "ddt-checkout-dev_appengine_deployer" {
  project = "${google_project.ddt-checkout-dev.project_id}"
  role    = "roles/appengine.deployer"

  members = [
    "group:gcp-ddt-developers@apszaz.com",
  ]
}


resource "google_project_iam_binding" "ddt-checkout-dev_appengine_appAdmin" {
  # wait for the cloudbuild service account to be created
  depends_on = [ "google_project_service.ddt-checkout-dev_cloudbuild" ]
  
  project = "${google_project.ddt-checkout-dev.project_id}"
  role    = "roles/appengine.appAdmin"

  members = [
    "group:gcp-ddt-ops@apszaz.com",
    "group:gcp-ddt-mamagers@apszaz.com",
    "serviceAccount:${google_project.ddt-checkout-dev.number}@cloudbuild.gserviceaccount.com",
  ]
}


resource "google_project_iam_binding" "ddt-checkout-test_appengine_codeViewer" {
  project = "${google_project.ddt-checkout-test.project_id}"
  role    = "roles/appengine.codeViewer"

  members = [
    "group:gcp-ddt-developers@apszaz.com",
    "group:gcp-ddt-qa@apszaz.com",
  ]
}


resource "google_project_iam_binding" "ddt-checkout-test_appengine_serviceAdmin" {
  project = "${google_project.ddt-checkout-test.project_id}"
  role    = "roles/appengine.serviceAdmin"

  members = [
    "group:gcp-ddt-ops@apszaz.com",
  ]
}


resource "google_project_iam_binding" "ddt-checkout-test_appengine_appViewer" {
  project = "${google_project.ddt-checkout-test.project_id}"
  role    = "roles/appengine.appViewer"

  members = [
    "group:gcp-ddt-mamagers@apszaz.com",
  ]
}


resource "google_project_iam_binding" "ddt-checkout-test_appengine_appAdmin" {
  # wait for the cloudbuild service account to be created
  depends_on = [ "google_project_service.ddt-checkout-test_cloudbuild" ]
  
  project = "${google_project.ddt-checkout-test.project_id}"
  role    = "roles/appengine.appAdmin"

  members = [
    "serviceAccount:${google_project.ddt-checkout-test.number}@cloudbuild.gserviceaccount.com",
  ]
}


resource "google_project_iam_binding" "ddt-checkout-prod_appengine_codeViewer" {
  project = "${google_project.ddt-checkout-prod.project_id}"
  role    = "roles/appengine.codeViewer"

  members = [
    "group:gcp-ddt-developers@apszaz.com",
    "group:gcp-ddt-qa@apszaz.com",
  ]
}


resource "google_project_iam_binding" "ddt-checkout-prod_appengine_serviceAdmin" {
  project = "${google_project.ddt-checkout-prod.project_id}"
  role    = "roles/appengine.serviceAdmin"

  members = [
    "group:gcp-ddt-ops@apszaz.com",
  ]
}


resource "google_project_iam_binding" "ddt-checkout-prod_appengine_appViewer" {
  project = "${google_project.ddt-checkout-prod.project_id}"
  role    = "roles/appengine.appViewer"

  members = [
    "group:gcp-ddt-mamagers@apszaz.com",
  ]
}


resource "google_project_iam_binding" "ddt-checkout-prod_appengine_appAdmin" {
  # wait for the cloudbuild service account to be created
  depends_on = [ "google_project_service.ddt-checkout-prod_cloudbuild" ]
  
  project = "${google_project.ddt-checkout-prod.project_id}"
  role    = "roles/appengine.appAdmin"

  members = [
    "serviceAccount:${google_project.ddt-checkout-prod.number}@cloudbuild.gserviceaccount.com",
  ]
}

