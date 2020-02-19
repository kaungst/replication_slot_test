#!/usr/bin/env bash

source script/common.sh

target_stage="$1"
image_name="$2"

echo "Building '$image_name' image (from '$target_stage' stage)..."
docker build \
  --target $target_stage \
  --tag $image_name \
  .
