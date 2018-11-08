# Cloud SQL instance: nonprod
resource "google_sql_database_instance" "ddt-db-app-data_nonprod" {
  project  = "${google_project.ddt-db-app-data.project_id}"
  name     = "nonprod"
  region   = "${var.gcp_region}"

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_user" "ddt-db-app-data_nonprod_user1" {
  name     = "user1"
  instance = "${google_sql_database_instance.ddt-db-app-data_nonprod.name}"
  project  = "${google_project.ddt-db-app-data.project_id}"
}

resource "google_sql_user" "ddt-db-app-data_nonprod_user2" {
  name     = "user2"
  instance = "${google_sql_database_instance.ddt-db-app-data_nonprod.name}"
  project  = "${google_project.ddt-db-app-data.project_id}"
}

resource "google_sql_database" "ddt-db-app-data_checkout-dev" {
  name      = "checkout-dev"
  instance  = "${google_sql_database_instance.ddt-db-app-data_nonprod.name}"
  project   = "${google_project.ddt-db-app-data.project_id}"
}

resource "google_sql_database" "ddt-db-app-data_checkout-test" {
  name      = "checkout-test"
  instance  = "${google_sql_database_instance.ddt-db-app-data_nonprod.name}"
  project   = "${google_project.ddt-db-app-data.project_id}"
}

# Cloud SQL instance: prod
resource "google_sql_database_instance" "ddt-db-app-data_prod" {
  project  = "${google_project.ddt-db-app-data.project_id}"
  name     = "prod"
  region   = "${var.gcp_region}"
  database_version = "MYSQL_5_6"

  settings {
    tier = "db-n1-standard-1"
  }
}

resource "google_sql_user" "ddt-db-app-data_prod_root" {
  name     = "root"
  instance = "${google_sql_database_instance.ddt-db-app-data_prod.name}"
  project  = "${google_project.ddt-db-app-data.project_id}"
}

resource "google_sql_database" "ddt-db-app-data_checkout" {
  name      = "checkout"
  instance  = "${google_sql_database_instance.ddt-db-app-data_prod.name}"
  project   = "${google_project.ddt-db-app-data.project_id}"
}

