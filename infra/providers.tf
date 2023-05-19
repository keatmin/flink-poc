provider "kafka-connect" {
  url = "http://localhost:8083"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
