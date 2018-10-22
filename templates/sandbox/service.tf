{% import 'macros.j2' as macros %}

{% for service in ['appengine', 'sql-component', 'storage-api', 'storage-component', 'cloudkms', 'cloudbuild', 'iap', 'sourcerepo'] %}

resource "google_project_service" "{{ context.short_id }}_{{ service }}" {
  project            = "{{ macros.project_id(context.short_id) }}"
  service            = "{{ service }}.googleapis.com"
  disable_on_destroy = false
}
{%- endfor %}