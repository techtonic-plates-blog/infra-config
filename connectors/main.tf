terraform {
  backend "s3" {

  }
}

resource "kafka-connect_connector" "auth-service-users-source" {
  name   = "auth-service-users-source"
  config = {
    "name"               = "auth-service-users-source"
    "connector.class"    = "io.debezium.connector.postgresql.PostgresConnector"
    "database.hostname"  = var.postgres_host
    "database.port"      = "5432"
    "database.user"      = var.debezium_user
    "database.password"  = var.debezium_pass
    "database.dbname"    = "auth_service"
    "topic.prefix"       = "users"
    "plugin.name"        = "pgoutput"
    "slot.name"          = "debezium_users_slot"
    "publication.name"   = "debezium_users_pub"
    "table.include.list" = "public.users"
  }
}

resource "kafka-connect_connector" "posts-service-users-sink" {
  name   = "posts-service-users-sink"
  config = {
    "name"                = "posts-service-users-sink"
    "connector.class"     = "io.confluent.connect.jdbc.JdbcSinkConnector"
    "connection.url"      = "jdbc:postgresql://${var.postgres_host}:5432/posts_service?stringtype=unspecified"
    "connection.user"     = var.debezium_user
    "connection.password" = var.debezium_pass
    "topics"              = "users.public.users"
    "auto.create"         = "false"
    "insert.mode"         = "upsert"
    "pk.mode"             = "record_key"
    "pk.fields"           = "id"
    "table.name.format"   = "users"
    "fields.whitelist"    = "id"
    "delete.enabled"      = "true"
  }
}

resource "kafka-connect_connector" "posts-service-posts-source" {
  name   = "posts-service-posts-source"
  config = {
    "name"               = "posts-service-posts-source"
    "connector.class"    = "io.debezium.connector.postgresql.PostgresConnector"
    "database.hostname"  = var.postgres_host
    "database.port"      = "5432"
    "database.user"      = var.debezium_user
    "database.password"  = var.debezium_pass
    "database.dbname"    = "posts_service"
    "topic.prefix"       = "posts"
    "plugin.name"        = "pgoutput"
    "slot.name"          = "debezium_posts_slot"
    "publication.name"   = "debezium_posts_pub"
    "table.include.list" = "public.posts"
  }
}
