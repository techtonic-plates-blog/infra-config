terraform {
  backend "s3" {

  }
}
resource "postgresql_database" "auth_service" {
  name  = "auth_service"
  owner = var.postgres_user
}

resource "postgresql_database" "posts_service" {
  name  = "posts_service"
  owner = var.postgres_user
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

# Grant CONNECT privilege on auth_service database
resource "postgresql_grant" "debezium_auth_connect" {
  database    = postgresql_database.auth_service.name
  role        = postgresql_role.debezium_auth_user.name
  object_type = "database"
  privileges  = ["CONNECT"]
}

# Grant USAGE on schema and SELECT on all tables in auth_service
resource "postgresql_grant" "debezium_auth_schema" {
  database    = postgresql_database.auth_service.name
  role        = postgresql_role.debezium_auth_user.name
  schema      = "public"
  object_type = "schema"
  privileges  = ["USAGE"]
}

resource "postgresql_grant" "debezium_auth_tables" {
  database    = postgresql_database.auth_service.name
  role        = postgresql_role.debezium_auth_user.name
  schema      = "public"
  object_type = "table"
  privileges  = ["SELECT"]
}

# Grant CONNECT privilege on posts_service database
resource "postgresql_grant" "debezium_posts_connect" {
  database    = postgresql_database.posts_service.name
  role        = postgresql_role.debezium_auth_user.name
  object_type = "database"
  privileges  = ["CONNECT"]
}

# Grant USAGE on schema and SELECT on all tables in posts_service
resource "postgresql_grant" "debezium_posts_schema" {
  database    = postgresql_database.posts_service.name
  role        = postgresql_role.debezium_auth_user.name
  schema      = "public"
  object_type = "schema"
  privileges  = ["USAGE"]
}

resource "postgresql_grant" "debezium_posts_tables" {
  database    = postgresql_database.posts_service.name
  role        = postgresql_role.debezium_auth_user.name
  schema      = "public"
  object_type = "table"
  privileges  = ["SELECT"]
}
