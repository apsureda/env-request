{% import 'macros.j2' as macros %}

{% for inst_name, inst_data in context['instances'].iteritems() %}

resource "google_sql_database_instance" "{{ context.short_id }}_{{ inst_name }}" {
  name = "{{ inst_name }}"
{% if inst_data.database_version %}
  database_version = "{{ inst_data.database_version }}"
{% endif %}
  region = "${var.gcp_region}"

{%  if inst_data.settings %}
  settings {
{% for sn, sv in inst_data.settings.iteritems() %}
    {{ sn }} = "{{ sv }}"
{% endfor %}
  }
{% endif %}
}
{%  if inst_data.user %}
resource "google_sql_user" "{{ context.short_id }}_{{ inst_name }}_{{ inst_data.user }}" {
  name     = "{{ inst_data.user }}"
  instance = "${google_sql_database_instance.{{ context.short_id }}_{{ inst_name }}.name}"
  password = "changeme"
  project  = "{{ macros.project_id(context.short_id) }}"
}
{% endif %}
{% if inst_data.databases %}
{% for database in inst_data.databases %}
resource "google_sql_database" "{{ context.short_id }}_{{ database.name }}" {
  name      = "{{ database.name }}"
  instance  = "${google_sql_database_instance.{{ context.short_id }}_{{ inst_name }}.name}"
}
{% endfor %}
{% endif %}
{% endfor %}
