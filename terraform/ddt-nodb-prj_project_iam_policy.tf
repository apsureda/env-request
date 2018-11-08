
resource "google_project_iam_binding" "ddt-nodb-prj-dev_appengine_serviceAdmin" {
  project = "${google_project.ddt-nodb-prj-dev.project_id}"
  role    = "roles/appengine.serviceAdmin"

  members = [
    "group:gcp-ddt-developers@apszaz.com",
  ]
}


resource "google_project_iam_binding" "ddt-nodb-prj-dev_appengine_deployer" {
  project = "${google_project.ddt-nodb-prj-dev.project_id}"
  role    = "roles/appengine.deployer"

  members = [
    "group:gcp-ddt-developers@apszaz.com",
  ]
}


resource "google_project_iam_binding" "ddt-nodb-prj-dev_appengine_appAdmin" {
  # wait for the cloudbuild service account to be created
  depends_on = [ "google_project_service.ddt-nodb-prj-dev_cloudbuild" ]
  
  project = "${google_project.ddt-nodb-prj-dev.project_id}"
  role    = "roles/appengine.appAdmin"

  members = [
    "group:gcp-ddt-ops@apszaz.com",
    "group:gcp-ddt-mamagers@apszaz.com",
    "serviceAccount:${google_project.ddt-nodb-prj-dev.number}@cloudbuild.gserviceaccount.com",
  ]
}


resource "google_project_iam_binding" "ddt-nodb-prj-test_appengine_codeViewer" {
  project = "${google_project.ddt-nodb-prj-test.project_id}"
  role    = "roles/appengine.codeViewer"

  members = [
    "group:gcp-ddt-developers@apszaz.com",
    "group:gcp-ddt-qa@apszaz.com",
  ]
}


resource "google_project_iam_binding" "ddt-nodb-prj-test_appengine_serviceAdmin" {
  project = "${google_project.ddt-nodb-prj-test.project_id}"
  role    = "roles/appengine.serviceAdmin"

  members = [
    "group:gcp-ddt-ops@apszaz.com",
  ]
}


resource "google_project_iam_binding" "ddt-nodb-prj-test_appengine_appViewer" {
  project = "${google_project.ddt-nodb-prj-test.project_id}"
  role    = "roles/appengine.appViewer"

  members = [
    "group:gcp-ddt-mamagers@apszaz.com",
  ]
}


resource "google_project_iam_binding" "ddt-nodb-prj-test_appengine_appAdmin" {
  # wait for the cloudbuild service account to be created
  depends_on = [ "google_project_service.ddt-nodb-prj-test_cloudbuild" ]
  
  project = "${google_project.ddt-nodb-prj-test.project_id}"
  role    = "roles/appengine.appAdmin"

  members = [
    "serviceAccount:${google_project.ddt-nodb-prj-test.number}@cloudbuild.gserviceaccount.com",
  ]
}


resource "google_project_iam_binding" "ddt-nodb-prj-prod_appengine_codeViewer" {
  project = "${google_project.ddt-nodb-prj-prod.project_id}"
  role    = "roles/appengine.codeViewer"

  members = [
    "group:gcp-ddt-developers@apszaz.com",
    "group:gcp-ddt-qa@apszaz.com",
  ]
}


resource "google_project_iam_binding" "ddt-nodb-prj-prod_appengine_serviceAdmin" {
  project = "${google_project.ddt-nodb-prj-prod.project_id}"
  role    = "roles/appengine.serviceAdmin"

  members = [
    "group:gcp-ddt-ops@apszaz.com",
  ]
}


resource "google_project_iam_binding" "ddt-nodb-prj-prod_appengine_appViewer" {
  project = "${google_project.ddt-nodb-prj-prod.project_id}"
  role    = "roles/appengine.appViewer"

  members = [
    "group:gcp-ddt-mamagers@apszaz.com",
  ]
}


resource "google_project_iam_binding" "ddt-nodb-prj-prod_appengine_appAdmin" {
  # wait for the cloudbuild service account to be created
  depends_on = [ "google_project_service.ddt-nodb-prj-prod_cloudbuild" ]
  
  project = "${google_project.ddt-nodb-prj-prod.project_id}"
  role    = "roles/appengine.appAdmin"

  members = [
    "serviceAccount:${google_project.ddt-nodb-prj-prod.number}@cloudbuild.gserviceaccount.com",
  ]
}

