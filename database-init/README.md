# Database Initialization Terraform Project

This project initializes the PostgreSQL databases required for the Kafka Connect connectors.

## Resources Created

- `auth_service` database
- `posts_service` database
- Debezium user with appropriate permissions
- Database tables (`users`, `posts`, and sink `users` table)
- PostgreSQL publications for CDC

## Usage

1. Set required environment variables:
   ```bash
   export TF_VAR_postgres_host="your-postgres-host"
   export TF_VAR_postgres_password="your-postgres-password"
   export TF_VAR_debezium_user="debezium"
   export TF_VAR_debezium_pass="your-debezium-password"
   ```

2. Initialize and apply:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Dependencies

This project should be applied **before** the connectors project, as it creates the databases and users that the connectors will use.

## Outputs

- Database names
- Publication names
- Debezium user information
