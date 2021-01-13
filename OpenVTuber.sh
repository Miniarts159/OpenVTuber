#!/bin/bash

# This script is based on Rogue Ren's work.
# This is his raw: https://pastebin.com/raw/t86VmYCc
# This is his YT Channel: https://www.youtube.com/channel/UC2J2hHf7DdBpVUjeuytMZzw

# The main program is defined as functions. This allows for them to be called at the end of the script.

# "RunOSF" is the base call to run the facial tracker. Functions will only be implimented.

function RunOSF()

{
echo -n "Run OpenSeeFace? (Y/N):"

read RUN

case $RUN in

	#If "Yes" then...
	Y | y)
		echo "Starting OpenSeeFace..." && \
			cd ~/Downloads/OpenSeeFace && \
			source env/bin/activate && \
			RunInputError=false && \
			python facetracker.py -c 0 -W 1280 -H 720 --discard-after 0 --scan-every 0 \
			--no-3d-adapt 1 --max-feature-updates 900
					;;
	#If "No" then...
	N | n)
		echo "Quitting Program..." && \
		RunInputError=false
			;;
	
	#If else then...
	*)
		echo "Unknown input... restarting..." && \
		RunInputError=true
				;;
esac
}

# ^^^^^This is the end of RunOSF^^^^^^^^

# "FirstTimeSetup" is an apt, git, pip, and wget-based download script which installs the following:
# git, wine, wine64, lutris, pip, virtualenv, VSeeFace, OpenSeeFace, and Arial Fonts for Wine64.

# The current specified download locatoin is ~/Downloads, but current plans are to allow user to set install folder.

function FirstTimeSetup()

{
echo -n "Do you need to perform a first-time setup? (Y/N):"
read SETUP

case $SETUP in
	#If "Yes" then...
	Y | y)
		sudo apt-get update -y && \
			sudo apt install git -y && \
			sudo apt install wine -y && \
			sudo apt install wine64 -y && \
			sudo apt install lutris -y && \
			sudo apt-get install python3 python3-pip python3-virtualenv git -y && \
			cd ~/Downloads && \
			wget https://github.com/emilianavt/VSeeFaceReleases/releases/download/v1.13.34p/VSeeFace-v1.13.34p.zip && \
			unzip VSeeFace-v1.13.34p.zip && \
			git clone https://github.com/emilianavt/OpenSeeFace && \
			cd OpenSeeFace && \
			virtualenv -p python3 env && \
			source env/bin/activate && \
			pip3 install onnxruntime==1.2.0 opencv-python pillow numpy && \
			cd ~/.wine64/drive_c/windows/Fonts && \
			wget https://www.cufonfonts.com/download/font/arial && \
			unzip arial && \
			SetupInputError=false
			RunOSFInstallComplete=true
					;;
	#If "No" then...
	N | n)
		echo "Ok, skipping..." && \
			SetupInputError=false && \
			RunOSFInstallComplete=true
					;;

	#If else then...
	*)
		echo "Unknown input... asking again..." && \
		SetupInputError=true
				;;
esac
}

function Run_or_Setup()

{
	echo -n "Do you want to run OpenSeeFace, or perform a first time setup? (RUN/SETUP):"
	read RUNORSETUP
	case $RUNORSETUP in

		RUN|Run|run)
			RunOSF
			until [ $RunInputError = false ]
			do
				RunOSF
				wait
			done
			;;

		SETUP|Setup|setup)
			FirstTimeSetup
			until [ $RunOSFInstallComplete = true ] 
			do	
				FirstTimeSetup
				wait
			done
			until [ $SetupInputError = false ]
			do
				FirstTimeSetup
				wait
			done
			;;
	esac
}

Run_or_Setup

unset RUN && unset SETUP && unset RunInputError && unset SetupInputError
