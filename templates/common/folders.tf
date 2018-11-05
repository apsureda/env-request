{% for folder in context.folders.values() %}
resource "google_folder" "{{ folder.folder_id }}" {
  display_name = "{{ folder.folder_name }}"
{% if folder.parent_id %}
  parent       = "${google_folder.{{ folder.parent_id }}.name}"
{% else %}
  parent       = "${var.gcp_root}"
{% endif %}
}

{% endfor %}
