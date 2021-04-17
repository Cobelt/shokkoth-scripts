#!/bin/bash

FILES=/data/github/shokkoth/assets/equipments/*.png
for f in $FILES
do
	convert $f -resize 100x100 $f
done