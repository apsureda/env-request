{% import 'macros.j2' as macros %}

{% for role in context['permissions'] %}

resource "google_project_iam_binding" "{{ context.short_id }}_{{ role }}" {
  project = "{{ macros.project_id(context.short_id, env) }}"
  role    = "roles/{{ role }}"

  members = [
    {% for member in context['permissions'][role] %}
    "{{ member }}",
    {%- endfor %}
  ]
}

{%- endfor %}
