


resource "google_cloudbuild_trigger" "ddt-nodb-prj-dev" {
  # wait for the cloudbuild API to be activated before creating the keyring
  depends_on = [ "google_project_service.ddt-nodb-prj-dev_cloudbuild" ]
  project  = "${google_project.ddt-nodb-prj-dev.project_id}"
  trigger_template {
    branch_name = "development"
    repo_name   = "github_apsureda_gae-std"
    project  = "${google_project.ddt-nodb-prj-dev.project_id}"
  }
  substitutions {
    _DB_CONNECTION_STR = ""
  }
  filename    = "cloudbuild.yaml"
  description = "Automated push to dev environment"
}

resource "google_cloudbuild_trigger" "ddt-nodb-prj-test" {
  # wait for the cloudbuild API to be activated before creating the keyring
  depends_on = [ "google_project_service.ddt-nodb-prj-test_cloudbuild" ]
  project  = "${google_project.ddt-nodb-prj-test.project_id}"
  trigger_template {
    branch_name = "release-.*"
    repo_name   = "github_apsureda_gae-std"
    project  = "${google_project.ddt-nodb-prj-test.project_id}"
  }
  substitutions {
    _DB_CONNECTION_STR = ""
  }
  filename    = "cloudbuild.yaml"
  description = "Automated push to test environment"
}

resource "google_cloudbuild_trigger" "ddt-nodb-prj-prod" {
  # wait for the cloudbuild API to be activated before creating the keyring
  depends_on = [ "google_project_service.ddt-nodb-prj-prod_cloudbuild" ]
  project  = "${google_project.ddt-nodb-prj-prod.project_id}"
  trigger_template {
    branch_name = "master"
    repo_name   = "github_apsureda_gae-std"
    project  = "${google_project.ddt-nodb-prj-prod.project_id}"
  }
  substitutions {
    _DB_CONNECTION_STR = ""
  }
  filename    = "cloudbuild.yaml"
  description = "Automated push to prod environment"
}