#!/bin/bash

DK=`basename $PWD`

docker stop $DK
docker container rm $DK

docker run -dti \
	--name $DK \
	--hostname $DK \
	--restart unless-stopped \
	-v /etc/localtime:/etc/localtime:ro \
	-v $PWD/dropbox:/dropbox \
	-p 3012:80 \
	-p 3013:443 \
	ubuntu:22.04

docker exec service nginx start

# fin
