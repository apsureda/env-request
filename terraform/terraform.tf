terraform {
  backend "gcs" {
    bucket = "apszaz-tfstate"
    prefix = "apszaz-dft-proj1"
  }
}
