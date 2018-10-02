#!/usr/bin/env bash

docker rm -fv myjenkins
docker image rm jenkins/jenkins
echo "Cleanup Successful"
