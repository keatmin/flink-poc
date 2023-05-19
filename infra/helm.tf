resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  chart            = "jetstack/cert-manager"
  version          = "1.11"
  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = true

  }
}

resource "helm_release" "flink-operator" {
  name             = "flink-operator"
  repository       = "https://downloads.apache.org/flink/flink-kubernetes-operator-1.5.0/"
  chart            = "flink-kubernetes-operator"
  namespace        = "flink-operator"
  create_namespace = true
}
