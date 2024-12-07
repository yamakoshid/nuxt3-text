#!/bin/bash

IMAGE_NAME=practice-nuxt-fastapi-backend

IMAGE_NAME=nginx:1.27.2-bookworm

docker run \
  --rm \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  aquasec/trivy:latest \
  image ${IMAGE_NAME}
