{% import 'macros.j2' as macros %}
{% for env in ['dev', 'test', 'prod'] %}
{% set prj_id =  context.short_id + "-" + env  %}
{% if context.random_suffix == 'true' %}
# add a random 4 hex char suffix to the project ID, so we can destry/apply this
# terraform file without running into project ID reuse conflicts.
resource "random_id" "{{ prj_id }}_id" {
  byte_length = 2
}
{% endif %}

resource "google_project" "{{ prj_id }}" {
  name            = "{{ context.project_id }}-{{ env }}"
  folder_id       = "${google_folder.{{ context.folder_id }}.id}"
  billing_account = "${var.gcp_billing_account_id}"
{% if context.random_suffix == 'true' %}
  project_id      = "{{ context.project_id }}-{{ env }}-${random_id.{{ prj_id }}_id.hex}"
{% else %}
  project_id      = "{{ context.project_id }}-{{ env }}"
{% endif %}
}

resource "google_app_engine_application" "{{ prj_id }}_app" {
  project = "{{ macros.project_id(context.short_id, env) }}"
  location_id = "${var.gcp_region}"
}

{%- endfor %}