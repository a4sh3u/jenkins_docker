#!/usr/bin/env bash

docker rm -fv myjenkins || true
sudo rm -rf jenkins_home || true
echo "Cleanup Successful"
