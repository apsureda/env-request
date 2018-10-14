{% for service in ['appengine', 'sql-component', 'storage-api', 'storage-component', 'cloudkms', 'cloudbuild', 'iap', 'sourcerepo'] %}

resource "google_project_service" "{{ current.short_id }}_{{ service }}" {
  project            = "${google_project.{{ current.short_id }}.project_id}"
  service            = "{{ service }}.googleapis.com"
  disable_on_destroy = false
}
{%- endfor %}