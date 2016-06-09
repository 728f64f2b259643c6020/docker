#!/usr/bin/env bash

set -e

docker-machine create -d virtualbox proxy

export DOCKER_IP=$(docker-machine ip proxy)

export CONSUL_IP=$(docker-machine ip proxy)

eval $(docker-machine env proxy)

docker-compose -f docker-compose-registrator.yml up -d consul proxy

docker-machine create -d virtualbox \
    --swarm --swarm-master \
    --swarm-discovery="consul://$CONSUL_IP:8500" \
    --engine-opt="cluster-store=consul://$CONSUL_IP:8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
    swarm-master

docker-machine create -d virtualbox \
    --swarm \
    --swarm-discovery="consul://$CONSUL_IP:8500" \
    --engine-opt="cluster-store=consul://$CONSUL_IP:8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
    swarm-node-1

docker-machine create -d virtualbox \
    --swarm \
    --swarm-discovery="consul://$CONSUL_IP:8500" \
    --engine-opt="cluster-store=consul://$CONSUL_IP:8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
    swarm-node-2

eval $(docker-machine env swarm-master)

export DOCKER_IP=$(docker-machine ip swarm-master)

docker-compose -f docker-compose-registrator.yml up -d registrator

eval $(docker-machine env swarm-node-1)

export DOCKER_IP=$(docker-machine ip swarm-node-1)

docker-compose -f docker-compose-registrator.yml up -d registrator

eval $(docker-machine env swarm-node-2)

export DOCKER_IP=$(docker-machine ip swarm-node-2)

docker-compose -f docker-compose-registrator.yml up -d registrator

eval $(docker-machine env swarm-master)

export DOCKER_IP=$(docker-machine ip swarm-master)
docker network create mycorp.com
docker-compose -p nosql -f docker-compose.yml up -d
docker-compose -p nosql -f docker-compose.yml scale slave=3
