


resource "google_cloudbuild_trigger" "ddt-checkout-dev" {
  # wait for the cloudbuild API to be activated before creating the keyring
  depends_on = [ "google_project_service.ddt-checkout-dev_cloudbuild" ]
  project  = "${google_project.ddt-checkout-dev.project_id}"
  trigger_template {
    branch_name = "development"
    repo_name   = "github_apsureda_gae-std"
    project  = "${google_project.ddt-checkout-dev.project_id}"
  }
  substitutions {
    _DB_CONNECTION_STR = ""
  }
  filename    = "cloudbuild.yaml"
  description = "Automated push to dev environment"
}

resource "google_cloudbuild_trigger" "ddt-checkout-test" {
  # wait for the cloudbuild API to be activated before creating the keyring
  depends_on = [ "google_project_service.ddt-checkout-test_cloudbuild" ]
  project  = "${google_project.ddt-checkout-test.project_id}"
  trigger_template {
    branch_name = "release-.*"
    repo_name   = "github_apsureda_gae-std"
    project  = "${google_project.ddt-checkout-test.project_id}"
  }
  substitutions {
    _DB_CONNECTION_STR = ""
  }
  filename    = "cloudbuild.yaml"
  description = "Automated push to test environment"
}

resource "google_cloudbuild_trigger" "ddt-checkout-prod" {
  # wait for the cloudbuild API to be activated before creating the keyring
  depends_on = [ "google_project_service.ddt-checkout-prod_cloudbuild" ]
  project  = "${google_project.ddt-checkout-prod.project_id}"
  trigger_template {
    branch_name = "master"
    repo_name   = "github_apsureda_gae-std"
    project  = "${google_project.ddt-checkout-prod.project_id}"
  }
  substitutions {
    _DB_CONNECTION_STR = ""
  }
  filename    = "cloudbuild.yaml"
  description = "Automated push to prod environment"
}