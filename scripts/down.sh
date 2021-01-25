## Stop the cluster
docker-compose down

## Delete cluster data
rm -rf /home/fer/mongodb-cluster-docker-compose/mongodata

## Delete containers
docker rm -f $(docker ps -a -q)

## Delete volumes
docker volume rm $(docker volume ls -q)