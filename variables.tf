// variables.tf
// Define input variables here.

variable "postgres_host" {
    type = string
    sensitive = false
}

variable "postgres_password" {
  type        = string
  sensitive   = true
  description = "From environmnent: TF_VAR_postgres_password"
}

variable "debezium_user" {
  type      = string
  sensitive = true
}

variable "debezium_pass" {
  type      = string
  sensitive = true
}

variable "minio_url" {
  type = string
  sensitive = false
}

variable "minio_access_key" {
  type = string
  sensitive = false
}

variable "minio_secret_key" {
  type = string
  sensitive = true
}