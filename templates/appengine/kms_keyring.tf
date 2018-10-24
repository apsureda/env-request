{% import 'macros.j2' as macros %}

{% for env in ['dev', 'test', 'prod'] %}
{% set prj_id =  context.short_id + "-" + env  %}

resource "google_kms_key_ring" "{{ prj_id }}" {
  name     = "CLOUDBUILD-SECRETS"
  project  = "{{ macros.project_id(context.short_id, env) }}"
  location = "${var.gcp_region}"
}

resource "google_kms_crypto_key" "{{ prj_id }}" {
  name            = "CLOUDBUILD-KEY"
  key_ring        = "${google_kms_key_ring.{{ prj_id }}.id}"
}

# only the build pipeline can decrypt data using this key
resource "google_kms_crypto_key_iam_binding" "{{ prj_id }}_decrypters" {
  crypto_key_id = "{{ prj_id }}/${var.gcp_region}/CLOUDBUILD-SECRETS/CLOUDBUILD-KEY"
  role          = "roles/cloudkms.cryptoKeyDecrypter"

  members = [
    "serviceAccount:${google_project.{{ prj_id }}.number}@cloudbuild.gserviceaccount.com",
  ]
}

# most teams can encrypt data using this key using the following gcloud command:
# gcloud kms encrypt --plaintext-file=secrets.sh \
#     --ciphertext-file=secrets-development.sh.enc --location=[REGION] \
#     --keyring=CLOUDBUILD-SECRETS --key=CLOUDBUILD-KEY --project=[PROJECT_ID]
resource "google_kms_crypto_key_iam_binding" "{{ prj_id }}_encrypters" {
  crypto_key_id = "{{ prj_id }}/${var.gcp_region}/CLOUDBUILD-SECRETS/CLOUDBUILD-KEY"
  role          = "roles/cloudkms.cryptoKeyEncrypter"

  members = [
    {% for member in context.team_mng + context.team_dev + context.team_ops %}
    "{{ member }}",
    {%- endfor %}

  ]
}

{%- endfor %}