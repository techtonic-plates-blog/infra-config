terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.15"
    }
  }
}

provider "postgresql" {
  host     = var.postgres_host
  port     = 5432
  username = var.postgres_user
  password = var.postgres_password
  database = "postgres"
  sslmode  = "disable"
}
