#!/bin/bash

podman run -t -i \
  --uidmap=1000:0:1 --gidmap=1000:0:1 \
  --uidmap=65534:1:1 --gidmap=65534:1:1 \
  --uidmap=0:2:999 --gidmap=0:2:999 \
  --mount type=bind,src=/home/pirmin/ot/opentitan,target=/home/dev/src \
  --mount type=bind,src=/nas/lowrisc/tools,target=/nas/lowrisc/tools,ro=true \
  localhost/opentitan:latest bash
