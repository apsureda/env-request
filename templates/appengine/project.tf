{% import 'macros.j2' as macros %}

{% for env in ['dev', 'test', 'prod'] %}
{% set prj_id =  context.short_id + "-" + env  %}

resource "random_id" "{{ prj_id }}_id" {
  byte_length = 2
}

resource "google_project" "{{ prj_id }}" {
  name                = "{{ context.project_id }}-{{ env }}"
  folder_id           = "{{ context.folder_id }}"
  billing_account     = "${var.gcp_billing_account_id}"
  project_id          = "{{ context.project_id }}-{{ env }}-${random_id.{{ prj_id }}_id.hex}"
}

resource "google_app_engine_application" "{{ prj_id }}_app" {
  project = "{{ macros.project_id(context.short_id, env) }}"
  location_id = "${var.gcp_region}"
}

{%- endfor %}