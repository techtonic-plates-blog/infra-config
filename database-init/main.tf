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

resource "postgresql_role" "debezium_auth_user" {
  name                    = var.debezium_user
  login                   = true
  password                = var.debezium_pass
  superuser               = true
  create_database         = true
  create_role             = true
  replication             = true
  bypass_row_level_security = true
}

# Grant CONNECT privilege on all databases
resource "postgresql_grant" "debezium_connect" {
  for_each    = postgresql_database.services
  database    = each.value.name
  role        = postgresql_role.debezium_auth_user.name
  object_type = "database"
  privileges  = ["CONNECT"]
}

# Grant USAGE on schema for all databases
resource "postgresql_grant" "debezium_schema" {
  for_each    = postgresql_database.services
  database    = each.value.name
  role        = postgresql_role.debezium_auth_user.name
  schema      = "public"
  object_type = "schema"
  privileges  = ["USAGE"]
}

# Grant SELECT on all tables for all databases
resource "postgresql_grant" "debezium_tables" {
  for_each    = postgresql_database.services
  database    = each.value.name
  role        = postgresql_role.debezium_auth_user.name
  schema      = "public"
  object_type = "table"
  privileges  = ["SELECT"]
}
