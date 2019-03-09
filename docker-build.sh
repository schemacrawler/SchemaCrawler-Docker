#!/bin/bash
set -e

# ## DOCKER
echo "Creating SchemaCrawler Docker container"

SCHEMACRAWLER_VERSION=15.05.01

# Create SchemaCrawler distribution
./schemacrawler-distribution.sh

# Print Docker version
pwd
docker version

# Build Docker image
docker build -t schemacrawler/schemacrawler .
docker tag schemacrawler/schemacrawler schemacrawler/schemacrawler:v$SCHEMACRAWLER_VERSION
docker tag schemacrawler/schemacrawler schemacrawler/schemacrawler:latest

# Deploy image to Docker Hub
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker push schemacrawler/schemacrawler
docker logout

# Remove local image
# docker rm schemacrawler/schemacrawler

