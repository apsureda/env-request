terraform {
  backend "gcs" {
    bucket = "{{ context.gcs_bucket }}"
    prefix = "{{ context.gcs_prefix }}"
  }
}
