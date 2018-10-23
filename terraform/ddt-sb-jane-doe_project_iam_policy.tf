
resource "google_project_iam_binding" "ddt-sb-jane-doe_owners" {
  project = "${google_project.ddt-sb-jane-doe.project_id}"
  role    = "roles/owner"

  members = [
        "gcp-ddt-ops@dft.gov.uk",    "gcp-ddt-mamagers@dft.gov.uk",    "janedoe@dft.gov.uk",  ]
}

resource "google_project_iam_binding" "ddt-sb-jane-doe_viewers" {
  project = "${google_project.ddt-sb-jane-doe.project_id}"
  role    = "roles/viewer"

  members = [
        
    "gcp-ddt-developers@dft.gov.uk",  ]
}