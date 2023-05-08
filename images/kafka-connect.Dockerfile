FROM confluentinc/cp-server-connect-base:7.4.0

RUN confluent-hub install --no-prompt confluentinc/kafka-connect-s3:10.4.3 && \
#    confluent-hub install --no-prompt debezium/debezium-connector-postgresql:1.7.1
    confluent-hub install --no-prompt confluentinc/kafka-connect-datagen:0.6.0

USER root

RUN mkdir /appuser && \
    chown -R appuser /etc/kafka-connect && \
    chown -R appuser /etc/kafka

COPY --chown=appuser init_connector.sh /appuser

USER appuser
WORKDIR /appuser

ENTRYPOINT ["./init_connector.sh"]
