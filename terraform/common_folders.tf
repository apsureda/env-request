resource "google_folder" "DFT-ORG" {
  display_name = "DFT-ORG"
  parent       = "${var.gcp_root}"
}

resource "google_folder" "DFT-ORG_DDT" {
  display_name = "DDT"
  parent       = "${google_folder.DFT-ORG.name}"
}

resource "google_folder" "DFT-ORG_SANDBOXES" {
  display_name = "SANDBOXES"
  parent       = "${google_folder.DFT-ORG.name}"
}

