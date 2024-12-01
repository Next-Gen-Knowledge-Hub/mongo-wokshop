#!/bin/bash

if docker images --format "{{.Repository}}" | grep -q "mongo"; then
    echo "Mongodb image exists locally."
else
    echo "Mongodb image does not exists locally. ---> pulling"
    docker pull mongo
fi

docker run -d \
    --name mongodb \
    -p 27017:27017 \
    -v mongodb_data:/data/db \
    mongo

docker ps
