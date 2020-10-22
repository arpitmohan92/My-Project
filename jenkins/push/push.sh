#!/bin/bash

echo "********************"
echo "** Pushing image ***"
echo "********************"

IMAGE="app"

echo "** Logging in ***"
docker login -u amsmzn -p Amsmzn@123
echo "*** Tagging image ***"
docker tag $IMAGE:$TAG amsmzn/$IMAGE:$TAG
echo "*** Pushing image ***"
docker push amsmzn/$IMAGE:$TAG
echo "*** Deleting previous image before tagging ***"
docker rmi $IMAGE:$TAG

