#!/bin/bash

# adjust kernel parameter
sudo sysctl -w vm.max_map_count=262144
sudo sysctl -p

# configure ECS container agent
echo ECS_CLUSTER=${ecs_cluster_name} >> /etc/ecs/ecs.config
