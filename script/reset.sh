#!/usr/bin/env bash

source script/common.sh

psql -h dummy_app_db postgres postgres < dev/dummy-app-db-seed.sql
kafka-topics --bootstrap-server broker:9092 --create --topic dummy_app.public.test_table1 --partitions 1 --replication-factor 1 --config cleanup.policy=compact
script/register_connector.sh connector_configs/dummy_app.json
