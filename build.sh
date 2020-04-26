#!/bin/bash

image=ttksm/geminabox
geminabox_version=1.2

docker build -t $image:$geminabox_version . --no-cache
docker tag $image:$geminabox_version $image:latest
