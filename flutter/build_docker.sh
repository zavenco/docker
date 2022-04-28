#!/usr/bin/env bash

set -e

docker buildx build --tag zavenco/flutter:${FLUTTER_VERSION/+/-} \
             --tag zavenco/flutter:$DOCKER_TAG \
             --build-arg flutter_version=$FLUTTER_VERSION \
             --platform=linux/arm64,linux/amd64 \
             --progress=plain \
             .
