variable "postgres_host" {
  type        = string
  sensitive   = false
  description = "PostgreSQL host"
}

variable "postgres_user" {
  type        = string
  sensitive   = false
  description = "PostgreSQL admin user"
  default     = "postgres"
}

variable "postgres_password" {
  type        = string
  sensitive   = true
  description = "PostgreSQL admin password. From environment: TF_VAR_postgres_password"
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
