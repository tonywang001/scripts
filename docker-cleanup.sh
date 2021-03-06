#!/bin/bash

echo "cleanup untagged docker images"
docker images --no-trunc | grep '<none>' | awk '{ print $3 }' | xargs -r docker rmi -f

echo "cleanup dead dead containers"
docker ps --filter status=dead --filter status=exited -aq | xargs docker rm -v

echo "remove unused volumes"
find '/var/lib/docker/volumes/' -mindepth 1 -maxdepth 1 -type d | grep -vFf <(docker ps -aq | xargs docker inspect | jq -r '.[] | .Mounts | .[] | .Name | select(.)') | xargs -r rm -fr

