#!/usr/bin/env bash

source script/common.sh

property_file=$1
curl -i -u dev-user:dev-password -X POST -H "Accept: application/json" -H "Content-Type: application/json" http://connect:8083/connectors/ -d @$property_file
