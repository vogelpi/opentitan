#!/bin/bash

podman start otc
echo "source ot-container-sourceme.bash"
podman exec -t -i --user 1000:1000 --workdir /home/dev/src otc bash
