#!/usr/bin/env bash

source script/common.sh

script/build_image.sh dev omada_kafka_connect:latest

# Take down existing containers to ensure they are re-created using the image we just built.
docker-compose down
