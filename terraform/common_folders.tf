resource "google_folder" "DFT-ORG" {
  display_name = "DFT-ORG"
  parent       = "${var.gcp_root}"
}

resource "google_folder" "DFT-ORG_DDT" {
  display_name = "DDT"
  parent       = "${google_folder.DFT-ORG.name}"
}

resource "google_folder" "DFT-ORG_DDT_SANDBOXES" {
  display_name = "SANDBOXES"
  parent       = "${google_folder.DFT-ORG_DDT.name}"
}

resource "google_folder" "DFT-ORG_DATABASES" {
  display_name = "DATABASES"
  parent       = "${google_folder.DFT-ORG.name}"
}

