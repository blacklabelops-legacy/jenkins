#!/bin/bash -x

set -o errexit    # abort script at first error

function cleanContainer() {
  local container=$1
  docker rm -f -v $container;true
}

cleanContainer $1
