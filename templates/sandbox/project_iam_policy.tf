resource "google_project_iam_binding" "{{ current.short_id }}_owners" {
  project = "${google_project.{{ current.short_id }}.project_id}"
  role    = "roles/owner"

  members = [
    {% for member in current.owners %}
    "{{ member }}",
    {%- endfor %}
  ]
}

resource "google_project_iam_binding" "{{ current.short_id }}_viewers" {
  project = "${google_project.{{ current.short_id }}.project_id}"
  role    = "roles/viewer"

  members = [
    {% for member in current.viewers %}
    
    "{{ member }}",
    {%- endfor %}
  ]
}