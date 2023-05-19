# Create a cluster with one control plane and two workers
resource "kind_cluster" "k8s" {
  name           = "dev"
  wait_for_ready = true
  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
      extra_port_mappings {
        container_port = 80
        host_port      = 80
      }
    }
    node {
      role = "worker"
    }

    node {
      role = "worker"
    }
  }
}
