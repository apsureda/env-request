terraform {
  backend "gcs" {
    bucket = "apszaz-tfstate"
    prefix = "dft-ddt-voldemort"
  }
}
