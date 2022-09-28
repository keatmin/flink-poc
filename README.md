# Flink POC
Flink data processing using Kafka

## Prerequisite
Download Apache Flink jar
```bash
http --download https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-connector-kafka/1.15.2/flink-sql-connector-kafka-1.15.2.jar
http --download https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-connector-kafka/1.15.2/flink-sql-avro-1.15.2.jar
```

## Datastream vs Table API
- Table API is an API that unifies both batch and stream
- Datastream is an API to implement stream processing application

## Gotchas
- Flink window can only be called on time attribute column, defined either using WATERMARK or processing time attribute using proc AS PROCTIME()
