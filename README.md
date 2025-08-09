# Kafka Migrations Terraform Project

This project is divided into two separate Terraform modules:

1. **Database Initialization** (`database-init/`) - Sets up PostgreSQL databases, users, and tables
2. **Kafka Connectors** (`connectors/`) - Creates and manages Kafka Connect connectors

## Project Structure

```
├── database-init/          # Database initialization Terraform module
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   └── README.md
├── connectors/             # Kafka connectors Terraform module
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   └── README.md
├── container/              # Container definitions
│   ├── Containerfile.database-init
│   └── Containerfile.connectors
├── .github/
│   └── workflows/
│       └── build-and-push.yml  # CI/CD pipeline
├── docker-compose.yaml     # Complete stack orchestration
├── .env.template          # Environment variables template
└── README.md              # This file
```

## Quick Start

1. **Set up environment variables:**
   ```bash
   cp .env.template .env
   # Edit .env with your actual values
   ```

2. **Deploy the complete stack:**
   ```bash
   docker-compose up --build
   ```

This will:
- Start PostgreSQL, Kafka, and Kafka Connect
- Initialize databases and create necessary tables/users
- Deploy Kafka Connect connectors for CDC

## Manual Deployment

If you prefer to run the projects individually:

### Database Initialization
```bash
cd database-init
terraform init
terraform plan
terraform apply
```

### Kafka Connectors
```bash
cd connectors
terraform init
terraform plan
terraform apply
```

## Data Flow

1. `auth_service.users` → Kafka topic `users.public.users` → `posts_service.users`
2. `posts_service.posts` → Kafka topic `posts.public.posts`

## Dependencies

- Docker and Docker Compose
- PostgreSQL with logical replication enabled
- Kafka Connect with Debezium and JDBC connectors

## CI/CD Pipeline

The project includes a GitHub Actions workflow that:

- **Builds container images** for both database-init and connectors
- **Publishes to GitHub Container Registry** (ghcr.io)
- **Supports multi-platform builds** (linux/amd64, linux/arm64)
- **Performs security scanning** with Trivy
- **Generates build attestations** for supply chain security

### Container Images

The pipeline automatically builds and publishes:
- `ghcr.io/techtonic-plates-blog/kafka-migrations-database-init`
- `ghcr.io/techtonic-plates-blog/kafka-migrations-connectors`

Images are tagged with:
- `latest` (from main branch)
- Branch names (for development)
- Semantic version tags (for releases)

### Using Pre-built Images

You can use pre-built images instead of building locally by modifying your docker-compose.yaml:

```yaml
services:
  database-init:
    image: ghcr.io/techtonic-plates-blog/kafka-migrations-database-init:latest
    # Remove the build section and use image instead
    environment:
      - TF_VAR_postgres_host=${POSTGRES_HOST}
      # ... rest of environment variables
    
  connectors:
    image: ghcr.io/techtonic-plates-blog/kafka-migrations-connectors:latest
    # Remove the build section and use image instead
    environment:
      - TF_VAR_postgres_host=${POSTGRES_HOST}
      # ... rest of environment variables
```

## Container Images

The following container images are automatically built and published to GitHub Container Registry:

- **Database Init**: `ghcr.io/techtonic-plates-blog/kafka-migrations-database-init:latest`
- **Connectors**: `ghcr.io/techtonic-plates-blog/kafka-migrations-connectors:latest`

### Using Pre-built Images

You can use the pre-built images by updating your docker-compose.yaml:

```yaml
services:
  database-init:
    image: ghcr.io/techtonic-plates-blog/kafka-migrations-database-init:latest
    # ... rest of configuration

  connectors:
    image: ghcr.io/techtonic-plates-blog/kafka-migrations-connectors:latest
    # ... rest of configuration
```

## Container Images

The following container images are automatically built and published to GitHub Container Registry:

- **Database Init**: `ghcr.io/techtonic-plates-blog/kafka-migrations-database-init:latest`
- **Connectors**: `ghcr.io/techtonic-plates-blog/kafka-migrations-connectors:latest`

### Using Pre-built Images

You can use the pre-built images by updating your docker-compose.yaml:

```yaml
services:
  database-init:
    image: ghcr.io/techtonic-plates-blog/kafka-migrations-database-init:latest
    # ... rest of configuration

  connectors:
    image: ghcr.io/techtonic-plates-blog/kafka-migrations-connectors:latest
    # ... rest of configuration
```
