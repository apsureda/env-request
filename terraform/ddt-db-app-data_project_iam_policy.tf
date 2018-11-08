

resource "google_project_iam_binding" "ddt-db-app-data_cloudsql_admin" {
  project = "${google_project.ddt-db-app-data.project_id}"
  role    = "roles/cloudsql.admin"

  members = [
    "group:gcp-glb-dba@apszaz.com",
  ]
}