terraform {
  required_providers {
    kafka-connect = {
      source  = "Mongey/kafka-connect"
      version = "0.4.3" # Check for latest
    }
  }
}

provider "kafka-connect" {
  url                  = "http://kafka-connect:8083"
  tls_auth_is_insecure = true
}
