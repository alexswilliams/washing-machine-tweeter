#!/usr/bin/env bash

# If this script fails to run on the `docker buildx` line, try:
# - enabling Experimental Features within docker
# - running `docker buildx create` followed by `docker buildx use ...` to create a builder instance

set -ex

function buildAndPush {
    local version=$1
    local nodeVersion=$2
    local imagename="alexswilliams/washing-machine-tweeter"
    local latest="last-build"
    if [ "$3" == "latest" ]; then latest="latest"; fi

    docker buildx build \
        --platform=linux/amd64 \
        --build-arg NODE_VERSION=${nodeVersion} \
        --build-arg VERSION=${version} \
        --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
        --build-arg VCS_REF=$(git rev-parse --short HEAD) \
        --tag ${imagename}:${version}-${nodeVersion} \
        --tag ${imagename}:${latest} \
        --push \
        --file Dockerfile .
}

# buildAndPush "0.1.0" "13.7.0-alpine"
# buildAndPush "0.1.0" "14.3.0-alpine"
buildAndPush "0.1.1" "14.5.0-alpine" "latest"

# curl -X POST "https://hooks.microbadger.com/images/alexswilliams/washing-machine-tweeter/7athI2g_9MllKFtomgGSyHy56q8="
