terraform {
  required_providers {
    kafka-connect = {
      source  = "Mongey/kafka-connect"
      version = "~> 0.2.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
    kind = {
      source  = "tehcyx/kind"
      version = "0.1.0"
    }
  }
}
