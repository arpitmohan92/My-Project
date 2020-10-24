#!/bin/bash

echo "********************"
echo "** Pushing image ***"
echo "********************"

IMAGE="app"

echo "** Logging in ***"
docker login -u amsmzn -p $PASS
echo "*** Tagging image ***"
docker tag $IMAGE:$BUILD_TAG amsmzn/$IMAGE:$BUILD_TAG
echo "*** Pushing image ***"
docker push amsmzn/$IMAGE:$BUILD_TAG
echo "*** Deleting previous image before tagging ***"
docker rmi $IMAGE:$BUILD_TAG

