{% import 'macros.j2' as macros %}
{% if context.random_suffix == 'true' %}
# add a random 4 hex char suffix to the project ID, so we can destry/apply this
# terraform file without running into project ID reuse conflicts.
resource "random_id" "{{ context.short_id }}_id" {
  byte_length = 2
}
{% endif %}

resource "google_project" "{{ context.short_id }}" {
  name            = "{{ context.project_id }}"
  folder_id       = "${google_folder.{{ context.folder_id }}.id}"
  billing_account = "${var.gcp_billing_account_id}"
{% if context.random_suffix == 'true' %}
  project_id      = "{{ context.project_id }}-${random_id.{{ context.short_id }}_id.hex}"
{% else %}
  project_id      = "{{ context.project_id }}"
{% endif %}
}

resource "google_app_engine_application" "{{ context.short_id }}_app" {
  project     = "{{ macros.project_id(context.short_id) }}"
  location_id = "${var.gcp_region}"
}