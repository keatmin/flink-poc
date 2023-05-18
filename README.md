# Flink POC
Flink data processing using Kafka

## Usage
- Run `docker-compose up --build --remove-orphans` if requires a full restart.
- Postgres can be removed in `docker-compose` if no need for CDC
- As the volume is mounted to local directory, all is needed is to `exec` into the job manager and run
```bash
./bin/flink run --python /local/opt/src/main.py
```
