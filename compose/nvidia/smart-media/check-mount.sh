#!/bin/sh

UUID="1383D6847197268C"
DEPENDENT_SERVICE="/mnt/movie"

while true; do
    if findmnt -n -o UUID | grep -q "$UUID"; then
        # Drive is mounted, do nothing (dependent_service will start via depends_on)
        sleep 5
    else
        # Drive is not mounted, stop all containers in the compose project
        docker compose down
        exit 0
    fi
done