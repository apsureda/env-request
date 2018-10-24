{% import 'macros.j2' as macros %}
{% for env in ['dev', 'test', 'prod'] %}
{% set prj_id =  context.short_id + "-" + env  %}
{% set cloudbuild_sa =  "serviceAccount:${google_project." + prj_id + ".number}@cloudbuild.gserviceaccount.com" %}
{% for role in context['permissions'][env] %}

resource "google_project_iam_binding" "{{ context.short_id }}-{{ env }}_{{ role }}" {
  project = "{{ macros.project_id(context.short_id, env) }}"
  role    = "roles/{{ role }}"

  members = [
    {% for member in context['permissions'][env][role] %}
    "{{ member | replace("[CLOUDBUILD_SA]", cloudbuild_sa) }}",
    {%- endfor %}
  ]
}

{%- endfor %}
{%- endfor %}
