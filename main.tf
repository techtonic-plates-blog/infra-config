terraform {
  backend "s3" {

  }
}

resource  "kafka-connect_connector" "auth-service-user-source" {

  name   = "auth-service-user-source"
  config = {
    "name"             = "auth-service-user-source"
    "connector.class"   = "io.debezium.connector.postgresql.PostgresConnector"
    "database.hostname" = var.postgres_host
    "database.port"     = "5432"
    "database.user"     = var.debezium_user
    "database.password" = var.debezium_pass
    "database.dbname"   = "auth_service"
    "topic.prefix"      = "user"
    "plugin.name"       = "pgoutput"
    "slot.name"         = "debezium_user_slot"
    "publication.name"  = "debezium_user_pub"
    "table.include.list"= "public.user"
  }
}
