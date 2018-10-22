{% import 'macros.j2' as macros %}

resource "google_project_iam_binding" "{{ context.short_id }}_owners" {
  project = "{{ macros.project_id(context.short_id) }}"
  role    = "roles/owner"

  members = [
    {% for member in context.owners %}
    "{{ member }}",
    {%- endfor %}
  ]
}

resource "google_project_iam_binding" "{{ context.short_id }}_viewers" {
  project = "{{ macros.project_id(context.short_id) }}"
  role    = "roles/viewer"

  members = [
    {% for member in context.viewers %}
    
    "{{ member }}",
    {%- endfor %}
  ]
}