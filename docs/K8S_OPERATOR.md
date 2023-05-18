# Using Flink k8s operator

1. Install cert manager
```bash
kubectl create -f https://github.com/jetstack/cert-manager/releases/download/v1.8.2/cert-manager.yaml
```
2. Add k8s operator for flink

```bas
helm repo add flink-kubernetes-operator-1.5.0 https://archive.apache.org/dist/flink/flink-kubernetes-operator-1.5.0/
helm install flink-kubernetes-operator flink-operator-repo/flink-kubernetes-operator
```
To find the list of stable versions please visit [Flink download](https://flink.apache.org/downloads.html)

- To deploy session mode do not define `job` in `yaml`
- BY default `spec.mode: native` allowing flink to manage k8s resources and allowing to dynamically allocate and deallocate TaskManager Pods
