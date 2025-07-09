# Kafka Migrations Terraform Project

## Structure

- `main.tf`: Main entry for resources and modules
- `variables.tf`: Input variables
- `outputs.tf`: Outputs
- `providers.tf`: Provider configuration
- `modules/`: Reusable Terraform modules
- `data/`: Source/data files (moved from `sources/`)

## Usage

1. Configure providers in `providers.tf`.
2. Add resources to `main.tf` or use modules.
3. Use `terraform init` and `terraform apply` as usual.
