{% import 'macros.j2' as macros %}

{% for env in ['dev', 'test', 'prod'] %}
{% set prj_id =  context.short_id + "-" + env  %}

{% for service in ['appengine', 'sql-component', 'storage-api', 'storage-component', 'cloudkms', 'cloudbuild', 'iap', 'sourcerepo'] %}

resource "google_project_service" "{{ prj_id }}_{{ service }}" {
  project            = "{{ macros.project_id(context.short_id) }}-{{ env }}"
  service            = "{{ service }}.googleapis.com"
  disable_on_destroy = false
}
{%- endfor %}
{%- endfor %}