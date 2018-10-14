data "terraform_remote_state" "dft_infra" {
  backend = "gcs"

  config {
    bucket = "{{ common.gcs_bucket }}"
    prefix = "{{ common.gcs_prefix }}"
  }
}
