#!/bin/bash

podman start dev
echo "source ot-container-sourceme.bash"
podman exec -t -i --user 1000:1000 --workdir /home/dev/src dev bash
