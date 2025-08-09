output "database_names" {
  description = "Names of all service databases"
  value       = { for k, v in postgresql_database.services : k => v.name }
}

output "debezium_user" {
  description = "Debezium user name"
  value       = postgresql_role.debezium_auth_user.name
  sensitive   = true
}

