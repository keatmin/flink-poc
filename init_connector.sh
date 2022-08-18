#!/bin/bash
# Launch Kafka Connect

export CONNECT_REST_ADVERTISED_HOST_NAME=$(hostname -I)
/etc/confluent/docker/run
