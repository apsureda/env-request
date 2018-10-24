


resource "google_cloudbuild_trigger" "ddt-checkout-dev" {
  project  = "${google_project.ddt-checkout-dev.project_id}"
  trigger_template {
    branch_name = "development"
    repo_name   = "github-apsureda-gae-std"
  }
  substitutions {
    _DB_CONNECTION_STR = ""
  }
  filename = "cloudbuild.yaml"
}

resource "google_cloudbuild_trigger" "ddt-checkout-test" {
  project  = "${google_project.ddt-checkout-test.project_id}"
  trigger_template {
    branch_name = "release-.*"
    repo_name   = "github-apsureda-gae-std"
  }
  substitutions {
    _DB_CONNECTION_STR = ""
  }
  filename = "cloudbuild.yaml"
}

resource "google_cloudbuild_trigger" "ddt-checkout-prod" {
  project  = "${google_project.ddt-checkout-prod.project_id}"
  trigger_template {
    branch_name = "master"
    repo_name   = "github-apsureda-gae-std"
  }
  substitutions {
    _DB_CONNECTION_STR = ""
  }
  filename = "cloudbuild.yaml"
}