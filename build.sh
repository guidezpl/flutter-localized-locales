#!/bin/bash
set -eu

cd $(dirname $0)

DATA_DIR=data
LOCALES_INDEX="$PWD/locales.json"

[[ ! -d "$DATA_DIR" ]] || rm -R "$DATA_DIR"
curl -L https://github.com/umpirsky/locale-list/archive/master.tar.gz | tar -xf - '*/locales.json'
find . -name 'locales.json' -exec bash -c 'mv $1 $(echo $1 | sed -e "s/\/locales\.json/\.json/g")' -- {} \;
ls -A -d locale-list-master/data/*/ | xargs rmdir
mv locale-list-master/data "$DATA_DIR"
rmdir locale-list-master

cd "$DATA_DIR"
find . -name '*.json' | sed -E "s/\.\///;s/\.json//" | jq -nRc '[inputs | select(length>0)] | sort' > "$LOCALES_INDEX"
