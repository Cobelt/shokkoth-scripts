#!/bin/bash

read -p "Which page ? [1] " page
page=${page:-1}
read -p "How much by page ? [200] " perPage
perPage=${perPage:-200}

skip=$(( ($page-1) * $perPage ))

curl "http://graphql.dev.shokkoth.tk/?query=query%20tota(%24skip%3A%20Int%2C%20%24limit%3A%20Int)%20%7B%0A%20%20resourceMany(skip%3A%20%24skip%2C%20limit%3A%20%24limit)%20%7B%0A%20%20%20%20ankamaId%0A%20%20%20%20imgUrl%0A%20%20%7D%0A%7D&variables=%7B%0A%20%20%22skip%22%3A%20$skip%2C%0A%20%20%22limit%22%3A%20$perPage%0A%7D" | jq -r -c '.data.resourceMany[]' | while read item ; do
	id=$(echo -e "${item}" | jq '.ankamaId')
	url=$(echo -e "${item}" | jq '.imgUrl')
	id=${id%\"}
	id=${id#\"}

	url=${url%\"}
	url=${url#\"}

	echo -e $id
	echo -e $url
	wget -O /data/github/shokkoth/assets/resources/$id.png https:$url -t 3
	read -p "Continuing in 0.5 Seconds...." -t 0.5
done
