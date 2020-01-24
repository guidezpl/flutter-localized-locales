#!/bin/bash
set -eu

cd $(dirname $0)

DATA_DIR=data
LANGUAGES_INDEX="$PWD/languages.json"

[[ ! -d "$DATA_DIR" ]] || rm -R "$DATA_DIR"
curl -L https://github.com/umpirsky/country-list/archive/master.tar.gz | tar -xf - '*/country.json'
find . -name 'country.json' -exec bash -c 'mv $1 $(echo $1 | sed -e "s/\/country\.json/\.json/g")' -- {} \;
ls -A -d country-list-master/data/*/ | xargs rmdir
mv country-list-master/data "$DATA_DIR"
rmdir country-list-master

cd "$DATA_DIR"
find . -name '*.json' | sed -E "s/\.\///;s/\.json//" | jq -nRc '[inputs | select(length>0)] | sort' > "$LANGUAGES_INDEX"
