#!/usr/bin/env bash

set -e

docker build --cache-from zavenco/flutter:${FLUTTER_VERSION/+/-} \
             --tag zavenco/flutter:${FLUTTER_VERSION/+/-} \
             --tag zavenco/flutter:$DOCKER_TAG \
             --build-arg flutter_version=$FLUTTER_VERSION \
             .
