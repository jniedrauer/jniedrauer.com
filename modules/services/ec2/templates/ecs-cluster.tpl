#!/bin/bash -x

mkdir -p /etc/ecs
echo 'ECS_CLUSTER=${cluster}' >> /etc/ecs/ecs.config
