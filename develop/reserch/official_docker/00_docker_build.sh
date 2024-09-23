#!/bin/bash
docker build -t default-user-image -f Dockerfile1 .
docker build -t custom-user-image -f Dockerfile2 .