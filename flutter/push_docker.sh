#!/usr/bin/env bash

set -e

BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$BRANCH" != "master" ]]; then
  exit 0;
fi

docker login --username $DOCKER_USER_NAME --password $DOCKER_PASSWORD

docker push zavenco/flutter:${FLUTTER_VERSION/+/-}
docker push zavenco/flutter:$DOCKER_TAG