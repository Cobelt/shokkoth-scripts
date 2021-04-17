#!/bin/bash

read -p "Download only missing files ? [y]/n" missingOnly
missingOnly=${missingOnly:-y}

cat /data/github/shokkoth/api/src/extractable/breeds.json | jq -r -c '.[]' | while read breed ; do
	# id=$(echo -e "${item}" | jq '._id')
	name=$(echo $breed | jq '.name' | tr '[:upper:]' '[:lower:]' | sed -e s/\"//g)
	maleUrl=$(echo -e $breed | jq '.skins.male.imgUrl' | sed -e s/\"//g)
	femaleUrl=$(echo -e $breed | jq '.skins.female.imgUrl' | sed -e s/\"//g)
    
    mkdir -p /data/github/shokkoth/assets/breeds/$name/full/male
    mkdir -p /data/github/shokkoth/assets/breeds/$name/full/female
    mkdir -p /data/github/shokkoth/assets/breeds/$name/heads

    echo -e ""
    echo -e "Doing $name ...."

    for i in {0..7}
    do
        if [[ ! $maleUrl = null ]]; then
            if [[ ! -f "/data/github/shokkoth/assets/breeds/$name/full/male/$i.png" || ! "$missingOnly" = "y" ]]; then
                echo "maleUrl : $maleUrl"
                maleOriented="${maleUrl/full\/1/full\/$i}"
                wget -O /data/github/shokkoth/assets/breeds/$name/full/male/$i.png $maleOriented -t 3
                sleep 0.3
            fi
        fi

        if [[ ! $femaleUrl = null ]]; then
            if [[ ! -f "/data/github/shokkoth/assets/breeds/$name/full/female/$i.png" || ! "$missingOnly" = "y" ]]; then
                femaleOriented="${femaleUrl/full\/1/full\/$i}"
                wget -O /data/github/shokkoth/assets/breeds/$name/full/female/$i.png $femaleOriented -t 3
                sleep 0.3
            fi
        fi
    done
done
