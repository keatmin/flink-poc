# Using Flink k8s operator

- To deploy session mode do not define `job` in `yaml` for `FlinkDeployment`
- BY default `spec.mode: native` allowing flink to manage k8s resources and allowing to dynamically allocate and deallocate TaskManager Pods
