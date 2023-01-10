#!/bin/bash

# Setup script for BYU ECEn Shop EAGLE files. Written by Jarom Christensen.

eagleDir=~/.local/share/Eagle/
eagleRelPath=EAGLE/byuPCB

# verify instalation of EAGLE and git
if ! git version > /dev/null; then
	echo "Error: git not installed."
	exit 1
fi

if [ ! -d $eagleDir ]; then
	echo "Error: EAGLE not installed"
	exit 1
fi

# clone repository, exit if already exists
git clone https://github.com/BYU-ELC/PcbDesign ~/$eagleRelPath || exit 1
echo

# set constants
eagleSettingsDir=$(ls -d ${eagleDir}settings/* | head -n 1)/
settings=${eagleSettingsDir}eaglerc

# set EAGLE directories
escapedPath=$(echo $eagleRelPath | sed 's/\//\\\//g')
for i in Cam Dru Lbr; do
	grep -c 'Directories\.'${i}' = .*\$HOME\/'${escapedPath} $settings > /dev/null || \
	sed -i 's/\(Directories\.'${i}' = "[^"]*\)/\1:\$HOME\/'${escapedPath}'/' $settings
done

# setup SSH script variables
minute=$[$RANDOM % 60]
croncmd="$minute */8 * * * /usr/bin/git -C ~/$eagleRelPath pull"

# add git update to crontab
if [ -e /caedm ]
then # running on caedm
	echo "Running on CAEDM"
	keyfile=~/.ssh/pcb_caedmKey

	# exit if keyfile already exists
	if [ -f $keyfile ]; then
		echo "SSH key already exists; assuming script has already been run. Exiting."
		exit 0
	fi

	# set up key pair
	ssh-keygen -f $keyfile -N '' > /dev/null
	cat ${keyfile}.pub >> ~/.ssh/authorized_keys

	# SSH to CAEDM, add git pull to crontab
	ssh ssh.et.byu.edu \
		-i $keyfile \
		-o UserKnownHostsFile=/dev/null \
		-o StrictHostKeyChecking=no \
		"(crontab -l; echo \"$croncmd\") | crontab -" \
		> /dev/null 2>&1

else # running on personal computer
	(crontab -l; echo "$croncmd") | crontab -
fi

echo "Setup complete."
echo "


                .  .:~!7?J7          :^:.  .
             .~7YPGB#####&G.         5##BG5J7^.
         .~JPB#########G55Y.        .PBB######BP?^
       .YB#############B?.           ..^5#########B?
        ^5#BY7Y##########G7           !P####G7!YG#Y:
          ~.   ~5##########P!       ^5####B?.   .^
                 ~P##########5~   :Y#####Y:
                   !P##########Y^?B####P~
                    .7G##############G!
                      .?G##########B?.
                        .P########G:
                         Y########P
                     ... Y########P...:
                    .PBGPB########BPGB#7
                    !##################P.
                     :^~!77??????77!~^:.

"

# remove script (it is usually downloaded standalone by users)
rm $0

