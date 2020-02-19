#!/usr/bin/env bash

source script/common.sh

# Using the default command specified in the `confluentinc/cp-kafka-connect-base` image:
# https://github.com/confluentinc/cp-docker-images/blob/3c5d67c17ee8aa6e65c2e6ebb3de1571e4eb5635/debian/kafka-connect-base/Dockerfile#L52
/etc/confluent/docker/run
