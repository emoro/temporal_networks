#!/bin/bash

FILE="fr-anim.mp4"

if [ -f $FILE ]; then
	echo "deleting old $FILE"
	rm $FILE
fi

ffmpeg -i animation/example%d.png -c:v libx264 -pix_fmt yuv420p $FILE
