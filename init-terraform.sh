#!/bin/sh

# Load environment variables from .dev.env if present
if [ -f .dev.env ]; then
  # shellcheck disable=SC1091
  . ./.dev.env
fi

# Check required env vars
: "${TF_VAR_minio_url:?TF_VAR_minio_url not set}"
: "${TF_VAR_minio_access_key:?TF_VAR_minio_access_key not set}"
: "${TF_VAR_minio_secret_key:?TF_VAR_minio_secret_key not set}"

cat > backend.hcl <<EOF
bucket = "tf-remote-state"
endpoints = { s3 = "${TF_VAR_minio_url}" }
access_key = "${TF_VAR_minio_access_key}"
secret_key = "${TF_VAR_minio_secret_key}"
key = "kafka-connectors/terraform-provision.tfstate"
region = "main"
skip_requesting_account_id = true
skip_credentials_validation = true
skip_metadata_api_check = true
skip_region_validation = true
use_path_style = true
EOF

terraform init -backend-config=backend.hcl
rm -f backend.hcl
