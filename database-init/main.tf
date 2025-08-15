terraform {
  backend "s3" {

  }
}

locals {
  databases = ["auth_service", "posts_service", "assets_service", "collections_service"]
}

resource "postgresql_database" "services" {
  for_each = toset(local.databases)
  name     = each.value
  owner    = var.postgres_user
}