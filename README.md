# Flink POC
Flink stream processing with Kafka using 2 different setups:
1. Docker compose
2. Kubernetes using kind + flink kubernetes operator

As this is probably the simplest to setup and test out pyflink jobs locally using docker compose, it was also important to have a deployment that would be the closest to understanding how it would be like self-hosting Flink.

## Architecture
### Docker Compose
Deployment consists of:
- zookeeper
- kafka broker
- kafka connect with 2 datagen connectors:
  - fleet_mgmt_sensors
  - orders
- schema registry
- kowl (Kafka UI)
- localstack (AWS stack for S3 and STS)
- postgres (for CDC with debezium and JDBC sink)
- flink job manager
- flink task manager

### k8s
- terraform to deploy `kind` cluster, `nginx`, and `cert-manager`
- same services as [docker-compose](#docker-compose) minus `kowl`, `localstack`, and `postgres`
- flink kubernetes operator in `flink-operator` namespace
- flink job manager is deployed in session mode

## Usage
### Using Docker Compose
- Run `docker-compose up --build --remove-orphans` if requires a full restart.
- Flink UI is accessible on `localhost:8081` and kowl UI is accessible via `localhost:8080`
- There is a need to run `terraform apply -target=module.deploy -autoapprove` to deploy datagen connectors which can be viewed on `kowl`
- Postgres can be removed in `docker-compose` if no need for CDC
- As the volume is mounted to local directory, all is needed is to `exec` into the job manager and run
```bash
./bin/flink run --python /opt/pyflink/src/main.py
```

### Using kind and Flink k8s Operator
#### Set up kind, nginx, cert-manager infra
```bash
cd infra
terraform init
terraform apply -auto-approve
```
pyflink `.py` jobs are baked into the [pyflink images](/images) and located in `/opt/flink` dir

#### Build docker image
After building the image from top dir,
```bash
docker build -f images/pyflink.Dockerfile -t <image_name> .
```

After that there are two ways to push the image into `kind` either:
1. run `kind load docker-image <image_name_1> <image_name_2> -n <kind_cluster_name>`
2. push it to a local registry that `kind` can pull from

*For option 1, ensure that during deployment `.spec.imagePullPolicy` option is set to `IfNotPresent`. [Due to the limitations of kind](https://kind.sigs.k8s.io/docs/user/quick-start/#loading-an-image-into-your-cluster) avoid using the `:latest` tag.*

*For option 2, for more details refer to [kind documentation](https://kind.sigs.k8s.io/docs/user/local-registry/) and updating the kind cluster terraform [deployment](infra/kubernetes.tf)*

#### Deploy dependencies
```bash
kubectl apply -f ./infra/k8s/zookeeper-deployment.yaml
kubectl apply -f ./infra/k8s/zookeeper-service.yaml
kubectl apply -f ./infra/k8s/broker-deployment.yaml
kubectl apply -f ./infra/k8s/broker-service.yaml
kubectl apply -f ./infra/k8s/connect-deployment.yaml
kubectl apply -f ./infra/k8s/connect-service.yaml
kubectl apply -f ./ingress.yaml #Used for Kafka Connect REST `curl localhost/connect` to access
kubectl apply -f ./infra/k8s/schema-registry-deployment.yaml
kubectl apply -f ./infra/k8s/schema-registry-service.yaml
kubectl apply -f ./infra/k8s/flink-deployment.yaml
kubectl apply -f ./infra/k8s/kafka-external-name.yaml
kubectl apply -f ./infra/k8s/schema-registry-external-name.yaml
kubectl apply -f ./infra/k8s/flink-session-jobs.yaml
```
There are better ways than running all of them one at a time, but it's important to see what each of them does.
As `flink-operator` and `flink`'s deployment are deployed in `flink-operator` namespace, `<service>-external-name.yaml` is used to refer to a service in another namespace without having to type out its resolved DNS.

For example, kafka broker is deployed in `default` namespace and flink session job in `flink-operator` namespace is trying to refer to the broker, we could either:
1. Use the full resolved DNS via `broker.default.svc.local.cluster` OR
2. Create an external name in `flink-operator` namespace to point to `broker.default.svc.local.cluster` so that it can be referred as `broker` in the namespace.
