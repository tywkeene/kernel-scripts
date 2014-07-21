#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
	printf "Usage: $0 <kernel to remove> <New kernel (optional)>\n"
fi

if [ "$1" == linux-`uname -r` ]; then
	printf "But you're using that kernel!\n"
fi

printf "Removing $1\n"

rm -rI $1

if [ -z "$2" ];
	printf "You didn't provide a new kernel so I can't set a new \
	symlink, sorry\n"
else
	printf "Setting new symlink linux->$2\n"
	ln -sf $2 linux
	ls -l linux
fi
