#!/bin/bash

# Setup script for BYU ECEn Shop EAGLE files. Written by Jarom Christensen.

eagleDir=~/.local/share/Eagle/
eagleRelPath=EAGLE/byuPCB

# verify instalation of EAGLE and git
if ! git version; then
	echo "Error: git not installed."
	return 1
fi

if [ ! -f $eagleDir ]; then
	echo "Error: EAGLE not installed"
	return 1
fi

# clone repository
git clone https://github.com/BYU-ELC/PcbDesign ~/$eagleRelPath

# set constants
eagleSettingsDir=$(echo ${eagleDir}settings/*/ | head -n 1)
settings=${eagleSettingsDir}eaglerc

# set EAGLE directories
escapedPath=$(echo $eagleRelPath | sed 's/\//\\\//g')
sed -i "s/(Directories\.Cam = .*)/\1:\$HOME\/${escapedPath}/" $settings
sed -i "s/(Directories\.Dru = .*)/\1:\$HOME\/${escapedPath}/" $settings
sed -i "s/(Directories\.Lbr = .*)/\1:\$HOME\/${escapedPath}/" $settings

# determine random time each hour
second=$[$RANDOM % 60]
minute=$[$RANDOM % 60]
croncmd="$second $minute */8 * * /usr/bin/git -C ~/$eagleRelPath pull"

# add git update to crontab
if [ -f /caedm ]
then # running on caedm
	keyfile=~/.ssh/caedmKey

	# set up key pair
	ssh-keygen -f $keyfile > /dev/null

	# SSH to CAEDM, add git pull to crontab
	ssh ssh.et.byu.edu -i $keyfile "(crontab -l; echo \"$croncmd\") | crontab -"

else # running on personal computer
	(crontab -l; echo "$croncmd") | crontab -
fi
