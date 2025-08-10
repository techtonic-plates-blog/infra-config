terraform {
  backend "s3" {

  }
}

locals {
  databases = ["auth_service", "posts_service", "assets_service"]
}

resource "postgresql_database" "services" {
  for_each = toset(local.databases)
  name     = each.value
  owner    = var.postgres_user
}

# Grant CONNECT privilege on all databases
resource "postgresql_grant" "debezium_connect" {
  for_each    = postgresql_database.services
  database    = each.value.name
  role        = var.debezium_user
  object_type = "database"
  privileges  = ["CONNECT"]
}

# Grant USAGE on schema for all databases
resource "postgresql_grant" "debezium_schema" {
  for_each    = postgresql_database.services
  database    = each.value.name
  role        = var.debezium_user
  schema      = "public"
  object_type = "schema"
  privileges  = ["USAGE"]
}

# Grant SELECT on all tables for all databases
resource "postgresql_grant" "debezium_tables" {
  for_each    = postgresql_database.services
  database    = each.value.name
  role        = var.debezium_user
  schema      = "public"
  object_type = "table"
  privileges  = ["SELECT"]
}
