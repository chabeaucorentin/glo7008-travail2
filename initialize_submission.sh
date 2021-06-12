#!/bin/bash

if command -v docker-compose &> /dev/null
then
    echo "Using docker-compose CLI"
    echo "Building images for localregistry.lc:30500"
    docker-compose build
    echo "Pushing images to localregistry.lc:30500"
    docker-compose push
    exit 0
fi

if command -v docker &> /dev/null
then
    echo "Using docker CLI"
    echo "Building images for localregistry.lc:30500"
    docker compose build
    echo "Pushing images to localregistry.lc:30500"
    docker compose push
    exit 0
fi

echo "No Docker or docker-compose command detected. Cannot initialize submission"
exit 1
