FROM confluentinc/cp-kafka-connect-base AS base

RUN confluent-hub install --no-prompt debezium/debezium-connector-postgresql:latest

ENV CONNECT_GROUP_ID connect-cluster

ENV CONNECT_KEY_CONVERTER io.confluent.connect.avro.AvroConverter

ENV CONNECT_VALUE_CONVERTER io.confluent.connect.avro.AvroConverter

ENV CONNECT_INTERNAL_KEY_CONVERTER org.apache.kafka.connect.json.JsonConverter
ENV CONNECT_INTERNAL_VALUE_CONVERTER org.apache.kafka.connect.json.JsonConverter
ENV CONNECT_INTERNAL_KEY_CONVERTER_SCHEMAS_ENABLE false
ENV CONNECT_INTERNAL_VALUE_CONVERTER_SCHEMAS_ENABLE false

ENV CONNECT_OFFSET_STORAGE_TOPIC connect-offsets
ENV CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR 3
ENV CONNECT_OFFSET_STORAGE_PARTITIONS 3

ENV CONNECT_CONFIG_STORAGE_TOPIC connect-configs
ENV CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR 3

ENV CONNECT_STATUS_STORAGE_TOPIC connect-status
ENV CONNECT_STATUS_STORAGE_REPLICATION_FACTOR 3

ENV CONNECT_OFFSET_FLUSH_INTERVAL_MS 10000

ENV CONNECT_REQUEST_TIMEOUT_MS 20000
ENV CONNECT_RETRY_BACKOFF_MS 500

ENV CONNECT_CONSUMER_REQUEST_TIMEOUT_MS 20000
ENV CONNECT_CONSUMER_RETRY_BACKOFF_MS 500

ENV CONNECT_PRODUCER_REQUEST_TIMEOUT_MS 20000
ENV CONNECT_PRODUCER_RETRY_BACKOFF_MS 500

ENV CONNECT_REST_EXTENSION_CLASSES org.apache.kafka.connect.rest.basic.auth.extension.BasicAuthSecurityRestExtension

FROM base AS deployment

# Based on advice from:
# https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
RUN groupadd -r omada-kafka-connect && useradd --no-log-init -r -g omada-kafka-connect omada-kafka-connect
USER omada-kafka-connect

FROM base AS dev

RUN apt-get update && apt-get install -y \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*
