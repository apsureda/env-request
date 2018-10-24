{% import 'macros.j2' as macros %}

{% for env, branch in [('dev', 'development'), ('test', 'release-.*'), ('prod', 'master')] %}
{% set prj_id =  context.short_id + "-" + env  %}


resource "google_cloudbuild_trigger" "{{ prj_id }}" {
  project  = "{{ macros.project_id(context.short_id, env) }}"
  trigger_template {
    branch_name = "{{ branch }}"
    repo_name   = "{{ context.source_repo }}"
  }
  substitutions {
    _DB_CONNECTION_STR = "{{ context.db_connection_str }}"
  }
  filename = "cloudbuild.yaml"
}

{%- endfor %}