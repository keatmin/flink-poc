FROM confluentinc/cp-server-connect-base:6.2.1

RUN confluent-hub install --no-prompt confluentinc/kafka-connect-s3:10.0.3 && \
    confluent-hub install --no-prompt debezium/debezium-connector-postgresql:1.7.1

ENV EXTRA_ARGS="-javaagent:/appuser/jmx_prometheus_javaagent-0.15.0.jar=8999:/appuser/jmx_exporter.yaml"

USER root

RUN mkdir /appuser && \
    chown -R appuser /etc/kafka-connect && \
    chown -R appuser /etc/kafka

COPY --chown=appuser init_connector.sh /appuser
COPY --chown=appuser jmx_exporter.yaml /appuser
COPY --chown=appuser libs/* /appuser

USER appuser
WORKDIR /appuser

ENTRYPOINT ["./init_connector.sh"]
