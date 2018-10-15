{% import 'macros.j2' as macros %}

resource "google_project_iam_binding" "{{ current.short_id }}_owners" {
  project = "{{ macros.project_id(current.short_id) }}"
  role    = "roles/owner"

  members = [
    {% for member in current.owners %}
    "{{ member }}",
    {%- endfor %}
  ]
}

resource "google_project_iam_binding" "{{ current.short_id }}_viewers" {
  project = "{{ macros.project_id(current.short_id) }}"
  role    = "roles/viewer"

  members = [
    {% for member in current.viewers %}
    
    "{{ member }}",
    {%- endfor %}
  ]
}