terraform {
  backend "s3" {

  }
}

# Database initialization for auth_service
resource "postgresql_database" "auth_service" {
  name  = "auth_service"
  owner = var.postgres_user
}

# Database initialization for posts_service
resource "postgresql_database" "posts_service" {
  name  = "posts_service"
  owner = var.postgres_user
}

# Create debezium user for auth_service
resource "postgresql_role" "debezium_auth_user" {
  name     = var.debezium_user
  login    = true
  password = var.debezium_pass
}

# Grant necessary permissions for debezium on auth_service
resource "postgresql_grant" "debezium_auth_db_connect" {
  database    = postgresql_database.auth_service.name
  role        = postgresql_role.debezium_auth_user.name
  schema      = "public"
  object_type = "database"
  privileges  = ["CONNECT"]
}

resource "postgresql_grant" "debezium_auth_schema_usage" {
  database    = postgresql_database.auth_service.name
  role        = postgresql_role.debezium_auth_user.name
  schema      = "public"
  object_type = "schema"
  privileges  = ["USAGE"]
}

resource "postgresql_grant" "debezium_auth_table_select" {
  database    = postgresql_database.auth_service.name
  role        = postgresql_role.debezium_auth_user.name
  schema      = "public"
  object_type = "table"
  privileges  = ["SELECT"]
}

# Grant replication privileges for debezium
resource "postgresql_grant" "debezium_replication" {
  role        = postgresql_role.debezium_auth_user.name
  object_type = "database"
  privileges  = ["REPLICATION"]
}

# Grant necessary permissions for debezium on posts_service
resource "postgresql_grant" "debezium_posts_db_connect" {
  database    = postgresql_database.posts_service.name
  role        = postgresql_role.debezium_auth_user.name
  schema      = "public"
  object_type = "database"
  privileges  = ["CONNECT"]
}

resource "postgresql_grant" "debezium_posts_schema_usage" {
  database    = postgresql_database.posts_service.name
  role        = postgresql_role.debezium_auth_user.name
  schema      = "public"
  object_type = "schema"
  privileges  = ["USAGE"]
}

resource "postgresql_grant" "debezium_posts_table_all" {
  database    = postgresql_database.posts_service.name
  role        = postgresql_role.debezium_auth_user.name
  schema      = "public"
  object_type = "table"
  privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE"]
}

# Create users table in auth_service
resource "postgresql_table" "users" {
  database = postgresql_database.auth_service.name
  schema   = "public"
  name     = "users"

  columns = [
    {
      name = "id"
      type = "SERIAL PRIMARY KEY"
    },
    {
      name = "username"
      type = "VARCHAR(255) UNIQUE NOT NULL"
    },
    {
      name = "email"
      type = "VARCHAR(255) UNIQUE NOT NULL"
    },
    {
      name = "created_at"
      type = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
    },
    {
      name = "updated_at"
      type = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
    }
  ]
}

# Create posts table in posts_service
resource "postgresql_table" "posts" {
  database = postgresql_database.posts_service.name
  schema   = "public"
  name     = "posts"

  columns = [
    {
      name = "id"
      type = "SERIAL PRIMARY KEY"
    },
    {
      name = "user_id"
      type = "INTEGER NOT NULL"
    },
    {
      name = "title"
      type = "VARCHAR(255) NOT NULL"
    },
    {
      name = "content"
      type = "TEXT"
    },
    {
      name = "created_at"
      type = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
    },
    {
      name = "updated_at"
      type = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
    }
  ]
}

# Create users table in posts_service (for sink connector)
resource "postgresql_table" "users_sink" {
  database = postgresql_database.posts_service.name
  schema   = "public"
  name     = "users"

  columns = [
    {
      name = "id"
      type = "INTEGER PRIMARY KEY"
    }
  ]
}

# Create replication slot and publication for auth_service
resource "postgresql_publication" "debezium_users_pub" {
  database = postgresql_database.auth_service.name
  name     = "debezium_users_pub"
  tables   = ["public.users"]
}

# Create replication slot and publication for posts_service
resource "postgresql_publication" "debezium_posts_pub" {
  database = postgresql_database.posts_service.name
  name     = "debezium_posts_pub"
  tables   = ["public.posts"]
}
