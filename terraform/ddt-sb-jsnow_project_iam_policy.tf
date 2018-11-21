

resource "google_project_iam_binding" "ddt-sb-jsnow_owner" {
  project = "${google_project.ddt-sb-jsnow.project_id}"
  role    = "roles/owner"

  members = [
    "group:gcp-ddt-ops@apszaz.com",
    "group:gcp-ddt-mamagers@apszaz.com",
    "user:alfonso@apszaz.com",
  ]
}


resource "google_project_iam_binding" "ddt-sb-jsnow_viewer" {
  project = "${google_project.ddt-sb-jsnow.project_id}"
  role    = "roles/viewer"

  members = [
    "group:gcp-ddt-developers@apszaz.com",
  ]
}

