#!/bin/bash

terraform init "terraform"
terraform apply -auto-approve \
  -var-file="params.tfvars" \
  "terraform"


