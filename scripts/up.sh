#!/bin/bash

# Start the cluster
docker-compose up -d 

# Config servers setup
docker-compose exec configsvr01 sh -c "mongo < /scripts/init-configserver.js"

## Shard servers setup
docker-compose exec shard01-a sh -c "mongo < /scripts/init-shard01.js"
docker-compose exec shard02-a sh -c "mongo < /scripts/init-shard02.js"
docker-compose exec shard03-a sh -c "mongo < /scripts/init-shard03.js"

## Router setup
sleep 15
docker-compose exec router01 sh -c "mongo < /scripts/init-router.js"

## Import dataset if it already exists in /scripts directory. Else, download before importing.
sleep 10

if [ -e trades.json ]
then
    docker-compose exec router01 sh -c "mongoimport --db proyecto --collection trades --type json --file /scripts/trades.json"
else
    wget https://dl.dropbox.com/s/gxbsj271j5pevec/trades.json
    docker-compose exec router01 sh -c "mongoimport --db proyecto --collection trades --type json --file /scripts/trades.json"
fi
