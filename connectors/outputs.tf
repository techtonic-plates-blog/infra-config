output "auth_service_users_source_connector" {
  description = "Name of the auth service users source connector"
  value       = kafka-connect_connector.auth-service-users-source.name
}

output "posts_service_users_sink_connector" {
  description = "Name of the posts service users sink connector"
  value       = kafka-connect_connector.posts-service-users-sink.name
}

output "posts_service_posts_source_connector" {
  description = "Name of the posts service posts source connector"
  value       = kafka-connect_connector.posts-service-posts-source.name
}
