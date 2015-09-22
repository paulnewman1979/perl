#!/bin/bash

nums=`ls -1 new.req/ | sort -n -r | head -n 1`
for ((i=0;i<=$nums;++i))
do
	if [ ! -f old.req/$i -a ! -f new.req/$i ]
	then
		reqdiff=0
	else
		reqdiff=`diff old.req/$i new.req/$i | wc -l`
	fi

	#cat old.resp/$i | sed 's/Set-Cookie: B=[^;]*;/Set-Cookie: /g' > 1.txt
	#cat new.resp/$i | sed 's/Set-Cookie: B=[^;]*;/Set-Cookie: /g' > 2.txt
	#respdiff=`diff 1.txt 2.txt | wc -l`
    respdiff=`diff old.resp/$i new.resp/$i | wc -l`
    if [ "$reqdiff" != "0" -o "$respdiff" != "0" ]
	then
		echo "$i $reqdiff $respdiff"
	fi
done
