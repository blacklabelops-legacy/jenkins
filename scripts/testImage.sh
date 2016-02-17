#!/bin/bash -x

set -o errexit    # abort script at first error

function testImage() {
  local tagname=$1
  local port=$2
  docker run -d -p $port:8080 --name=$tagname blacklabelops/jenkins:$tagname
  sleep 10
  curl --retry 10 --retry-delay 10 -v http://localhost:$port
  docker stop $tagname
}

testImage $1 $2
