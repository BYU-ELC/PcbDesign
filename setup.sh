#!/bin/bash

# Setup script for BYU ECEn Shop EAGLE files. Written by Jarom Christensen.

eagleDir=~/.local/share/Eagle/
eagleRelPath=EAGLE/byuPCB

# verify instalation of EAGLE and git
if ! git version; then
	echo "Error: git not installed."
	exit 1
fi

if [ ! -d $eagleDir ]; then
	echo "Error: EAGLE not installed"
	exit 1
fi

# clone repository
git clone https://github.com/BYU-ELC/PcbDesign ~/$eagleRelPath

# set constants
eagleSettingsDir=$(ls -d ${eagleDir}settings/* | head -n 1)/
settings=${eagleSettingsDir}eaglerc

# set EAGLE directories
escapedPath=$(echo $eagleRelPath | sed 's/\//\\\//g')
for i in Cam Dru Lbr; do
	sed -i 's/\(Directories\.'${i}' = "[^"]*\)/\1:\$HOME\/'${escapedPath}'/' $settings
done

# determine random time each hour
second=$[$RANDOM % 60]
minute=$[$RANDOM % 60]
croncmd="$second $minute */8 * * /usr/bin/git -C ~/$eagleRelPath pull"
echo "$croncmd"

# add git update to crontab
if [ -e /caedm ]
then # running on caedm
	echo "Running on CAEDM"
	keyfile=~/.ssh/caedmKey

	# set up key pair
	ssh-keygen -f $keyfile -N '' > /dev/null

	# SSH to CAEDM, add git pull to crontab
	ssh ssh.et.byu.edu \
		-i $keyfile \
		-o UserKnownHostsFile=/dev/null \
		-o StrictHostKeyChecking=no \
		"(crontab -l; echo \"$croncmd\") | crontab -"

else # running on personal computer
	(crontab -l; echo "$croncmd") | crontab -
fi
