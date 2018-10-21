
resource "google_project_iam_binding" "ddt-sb-johndoe_owners" {
  project = "${google_project.ddt-sb-johndoe.project_id}"
  role    = "roles/owner"

  members = [
        "gcp-ddt-ops@dft.gov.uk",    "gcp-ddt-mamagers@dft.gov.uk",    "johndoe@dft.gov.uk",  ]
}

resource "google_project_iam_binding" "ddt-sb-johndoe_viewers" {
  project = "${google_project.ddt-sb-johndoe.project_id}"
  role    = "roles/viewer"

  members = [
        
    "gcp-ddt-developers@dft.gov.uk",  ]
}