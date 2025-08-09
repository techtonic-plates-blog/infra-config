# Kafka Connectors Terraform Project

This project creates and manages Kafka Connect connectors for Change Data Capture (CDC) between PostgreSQL databases.

## Connectors Created

- **auth-service-users-source**: Debezium PostgreSQL source connector for the `users` table in `auth_service` database
- **posts-service-users-sink**: JDBC sink connector to replicate users data to `posts_service` database
- **posts-service-posts-source**: Debezium PostgreSQL source connector for the `posts` table in `posts_service` database

## Prerequisites

1. The database initialization project must be applied first
2. Kafka Connect cluster must be running and accessible
3. Required Kafka Connect plugins must be installed:
   - Debezium PostgreSQL connector
   - Confluent JDBC connector

## Usage

1. Set required environment variables:
   ```bash
   export TF_VAR_postgres_host="your-postgres-host"
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

This project depends on:
- Database initialization project (must be applied first)
- Running Kafka Connect cluster
- PostgreSQL databases with proper permissions

## Data Flow

1. `auth_service.users` → Kafka topic `users.public.users` → `posts_service.users`
2. `posts_service.posts` → Kafka topic `posts.public.posts`

## Outputs

- Names of all created connectors
