resource "google_project_service" "infrastructure_compute" {
  project            = "${google_project.infrastructure.project_id}"
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "infrastructure_logging" {
  project            = "${google_project.infrastructure.project_id}"
  service            = "logging.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "infrastructure_monitoring" {
  project            = "${google_project.infrastructure.project_id}"
  service            = "monitoring.googleapis.com"
  disable_on_destroy = false
}
