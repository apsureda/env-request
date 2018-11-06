{% import 'macros.j2' as macros %}

{% for env, branch in [('dev', 'development'), ('test', 'release-.*'), ('prod', 'master')] %}
{% set prj_id =  context.short_id + "-" + env  %}


resource "google_cloudbuild_trigger" "{{ prj_id }}" {
  # wait for the cloudbuild API to be activated before creating the keyring
  depends_on = [ "google_project_service.{{ prj_id }}_cloudbuild" ]
  project  = "{{ macros.project_id(context.short_id, env) }}"
  trigger_template {
    branch_name = "{{ branch }}"
    repo_name   = "{{ context.source_repo }}"
    project  = "{{ macros.project_id(context.short_id, env) }}"
  }
  substitutions {
    _DB_CONNECTION_STR = "{{ context.db_connection_str }}"
  }
  filename    = "cloudbuild.yaml"
  description = "Automated push to {{ env }} environment"
}

{%- endfor %}