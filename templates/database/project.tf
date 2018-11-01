{% import 'macros.j2' as macros %}

resource "random_id" "{{ context.short_id }}_id" {
  byte_length = 2
}

resource "google_project" "{{ context.short_id }}" {
  name            = "{{ context.project_id }}"
  folder_id       = "{{ context.folder_id }}"
  billing_account = "${var.gcp_billing_account_id}"
  project_id      = "{{ context.project_id }}-${random_id.{{ context.short_id }}_id.hex}"
}

resource "google_app_engine_application" "{{ context.short_id }}_app" {
  project     = "{{ macros.project_id(context.short_id) }}"
  location_id = "${var.gcp_region}"
}