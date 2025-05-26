#!/bin/bash

DK=`basename $PWD`

echo paramos $DK
docker stop $DK

echo borramos $DK
docker container rm $DK

echo arrancamos $DK
docker run -dti \
	--name $DK \
	--restart unless-stopped \
	-v /etc/localtime:/etc/localtime:ro \
	-p 3011:5000 \
	-v $PWD/dropbox:/dropbox \
	-e LT_LOAD_ONLY=en,es,zh,de \
	-e LT_DISABLE_WEB_UI=true \
	-e LT_DEBUG=true \
	libretranslate/libretranslate

# fin

