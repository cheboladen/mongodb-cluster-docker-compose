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

## Import dataset
sleep 10
docker-compose exec router01 sh -c "mongoimport --db proyecto --collection trades --type json --file /scripts/trades.json"