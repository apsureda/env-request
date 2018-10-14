terraform {
  backend "gcs" {
    bucket = "{{ common.gcs_bucket }}"
    prefix = "{{ common.gcs_prefix }}"
  }
}
