data "terraform_remote_state" "dft_infra" {
  backend = "gcs"
  config {
    bucket = "apszaz-tfstate"
    prefix = "dft-ddt-draco"
  }
}
