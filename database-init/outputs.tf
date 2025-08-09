output "auth_service_database_name" {
  description = "Name of the auth service database"
  value       = postgresql_database.auth_service.name
}

output "posts_service_database_name" {
  description = "Name of the posts service database"
  value       = postgresql_database.posts_service.name
}

output "debezium_user" {
  description = "Debezium user name"
  value       = postgresql_role.debezium_auth_user.name
  sensitive   = true
}

output "users_publication_name" {
  description = "Publication name for users table"
  value       = postgresql_publication.debezium_users_pub.name
}

output "posts_publication_name" {
  description = "Publication name for posts table"
  value       = postgresql_publication.debezium_posts_pub.name
}
