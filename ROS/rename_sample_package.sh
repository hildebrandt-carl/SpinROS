#!/bin/bash

if [ $# -lt 1 ] || [ $# -gt 1 ]; then
	echo usage: ./rename_sample_package.sh \<name\>
	exit
fi

find . -exec rename "s/sample_package/$1/" {} +
find . -type f -exec sed -i -e "s/sample_package/$1/g" {} +