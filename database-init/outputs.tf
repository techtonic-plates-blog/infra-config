output "database_names" {
  description = "Names of all service databases"
  value       = { for k, v in postgresql_database.services : k => v.name }
}

