
resource "google_project_iam_binding" "ddt-sb-john-doe2_owners" {
  project = "${google_project.ddt-sb-john-doe2.project_id}"
  role    = "roles/owner"

  members = [
        "gcp-ddt-ops@dft.gov.uk",    "gcp-ddt-mamagers@dft.gov.uk",    "johndoe@dft.gov.uk",  ]
}

resource "google_project_iam_binding" "ddt-sb-john-doe2_viewers" {
  project = "${google_project.ddt-sb-john-doe2.project_id}"
  role    = "roles/viewer"

  members = [
        
    "gcp-ddt-developers@dft.gov.uk",  ]
}