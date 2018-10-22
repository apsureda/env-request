data "terraform_remote_state" "dft_infra" {
  backend = "gcs"

  config {
    bucket = "{{ context.gcs_bucket }}"
    prefix = "{{ context.gcs_prefix }}"
  }
}
