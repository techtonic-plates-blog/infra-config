variable "postgres_host" {
  type        = string
  sensitive   = false
  description = "PostgreSQL host"
}

variable "debezium_user" {
  type        = string
  sensitive   = true
  description = "Debezium user for replication"
}

variable "debezium_pass" {
  type        = string
  sensitive   = true
  description = "Debezium user password"
}
