#!/bin/bash
. constants

printf "$BRIGHT"
printf "##################################################################################\n"
printf "# Started ProxySQL / Orchestrator / MySQL Docker Cluster Provisioner!            #\n"
printf "##################################################################################\n"
printf "$NORMAL"

sleep 1

docker-compose up -d
./bin/docker-mysql-post.bash && ./bin/docker-proxy-post.bash && ./bin/docker-orchestrator-post.bash

if [[ -z "$1" ]]; then
    ./bin/docker-benchmark.bash
fi
