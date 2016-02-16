#!/bin/bash

NEW_HOST=host1
OLD_HOST=host2

cat select.diff.sh.bak | sed "s/NEW_HOST/$NEW_HOST/g" | sed "s/OLD_HOST/$OLD_HOST/g" > select.diff.sh
chmod +x select.diff.sh
mkdir -p ../result/$NEW_HOST ../result/$OLD_HOST

cat rerun.diff.sh.bak | sed "s/NEW_HOST/$NEW_HOST/g" | sed "s/OLD_HOST/$OLD_HOST/g" > rerun.diff.sh
chmod +x rerun.diff.sh
mkdir -p ../bak/$NEW_HOST ../bak/$OLD_HOST

cat diff.sh.bak | sed "s/NEW_HOST/$NEW_HOST/g" | sed "s/OLD_HOST/$OLD_HOST/g" > diff.sh
chmod +x diff.sh

#nohup cat ../data/global.txt | ./result.comp.pl $NEW_HOST $OLD_HOST >view.txt &
nohup cat ../data/test.txt | ./result.comp.pl $NEW_HOST $OLD_HOST >view.txt &
