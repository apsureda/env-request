

resource "google_project_iam_binding" "ddt-sb-john-doe_owner" {
  project = "${google_project.ddt-sb-john-doe.project_id}"
  role    = "roles/owner"

  members = [
        "group:gcp-ddt-ops@dft.gov.uk",    "group:gcp-ddt-mamagers@dft.gov.uk",    "user:johndoe@dft.gov.uk",  ]
}
resource "google_project_iam_binding" "ddt-sb-john-doe_viewer" {
  project = "${google_project.ddt-sb-john-doe.project_id}"
  role    = "roles/viewer"

  members = [
        "group:gcp-ddt-developers@dft.gov.uk",  ]
}