#!/bin/bash

if [ $# -ne 2 ]
then
	echo "usage"
fi

if [ "$1" == "req" ]
then
	vim -d old.req/$2 new.req/$2
else
	vim -d old.resp/$2 new.resp/$2
fi

