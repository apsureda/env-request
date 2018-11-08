terraform {
  backend "gcs" {
    bucket = "apszaz-tfstate"
    prefix = "dft-infra"
  }
}