data "terraform_remote_state" "pos_net" {
  backend = "gcs"

  config {
    bucket = "apszaz-tfstate"
    prefix = "apszaz-dft-proj1"
  }
}
