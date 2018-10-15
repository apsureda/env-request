{% import 'macros.j2' as macros %}

resource "random_id" "{{ current.short_id }}_id" {
  byte_length = 2
}

resource "google_project" "{{ current.short_id }}" {
  name                = "{{ current.project_id }}"
  folder_id           = "{{ current.folder_id }}"
  billing_account     = "${var.gcp_billing_account_id}"
  project_id          = "{{ current.project_id }}-${random_id.{{ current.short_id }}_id.hex}"
}

resource "google_app_engine_application" "{{ current.short_id }}_app" {
  project     = "{{ macros.project_id(current.short_id) }}"
  location_id = "${var.gcp_region}"
}