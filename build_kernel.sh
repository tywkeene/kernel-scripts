#!/bin/bash

GIT_REMOTE="origin"
GIT_BRANCH="master"

if [ -z "$1" ]; then
	printf "Usage $0 <kernel directory>\n"
	exit -1
fi

cd $1

if [ $? != 0 ]; then
	printf "There's no kernel there\n"
	exit -1
fi

printf "Running pre-build cleaning work\n"
make mrproper
make clean

printf "We are.. "

if [ -e ".git" ]; then
	printf "a git tree, resetting and pulling\n"
	git reset --hard
	git pull $GIT_REMOTE $GIT_BRANCH
else
	printf "not a git tree\n"
fi

printf "Running make...\n"

printf "Checking for .config\n"

if [ ! -e ".config" ]; then
	printf "Not found, trying old .config from /boot\n"
	if [ ! -e "/boot/config-`uname -r`" ]; then
		printf "Not in /boot either..\n"
	fi

	cp "/boot/config-`uname -r`" .config
	if [ $? != 0 ]; then
		read -p "Failed to get old config, run 'make menuconfig' instead? (y/n) " -n 1 -r 
		echo
		if [ ! $REPLY =~ ^[Yy]$ ]; then
			make menuconfig
		fi
	else
		printf "Got old config, continuing to build\n"
	fi
else
	printf "old .config found $PWD\n"
	read -p "Run 'make menuconfig' to make changes?(y/n) " -n 1 -r 
	echo
	if [ ! $REPLY =~ ^[Yy]$ ]; then
		make menuconfig
	fi
fi

make

if [ $? !=  0 ]; then
	printf "Unsuccessful build, dying\n"
	exit -1
fi

printf "Successful build, continuing\n"
printf "Running make modules_install/install\n"

su -c 'make modules_install'
su -c 'make install'

printf "Updating grub.cfg\n"
su -c 'grub2-mkconfig -o /boot/grub/grub.cfg'

printf "All done\n"
