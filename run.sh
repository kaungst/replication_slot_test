#!/usr/bin/env bash

source script/common.sh

echo "Waiting for Kafka Connect..."
while [[ $(curl -u dev-user:dev-password -s -o /dev/null -w %{http_code} http://localhost:8083/connectors) != 200 ]]; do
  sleep 10.0
  echo "Splines reticulating..."
done
echo "Connect is ready!"

exec docker-compose exec connect "$@"
