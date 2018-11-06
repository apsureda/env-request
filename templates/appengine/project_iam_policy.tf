{% import 'macros.j2' as macros %}
{% for env in ['dev', 'test', 'prod'] %}
{% set prj_id =  context.short_id + "-" + env  %}
{% set cloudbuild_sa =  "serviceAccount:${google_project." + prj_id + ".number}@cloudbuild.gserviceaccount.com" %}
{% for role in context['permissions'][env] %}

resource "google_project_iam_binding" "{{ context.short_id }}-{{ env }}_{{ role | replace(".", "_") }}" {
{% if '[CLOUDBUILD_SA]' in context['permissions'][env][role] %}
  # wait for the cloudbuild service account to be created
  depends_on = [ "google_project_service.{{ prj_id }}_cloudbuild" ]
  
{% endif %}
  project = "{{ macros.project_id(context.short_id, env) }}"
  role    = "roles/{{ role }}"

  members = [
{% for member in context['permissions'][env][role] %}
    "{{ member | replace("[CLOUDBUILD_SA]", cloudbuild_sa) }}",
{% endfor %}
  ]
}

{% endfor %}
{% endfor %}
