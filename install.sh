#!/bin/bash

set -e

BSHOME=~/bstudio
launcher=~/.local/share/applications/bootstrapstudio.desktop
association=~/.local/share/mime/packages/bootstrapstudio.xml
URL="https://github.com/gaganyadav80/bootstrap-crack-linux/releases/download/v5.8.3/Bootstrap-Studio-5.8.3_x64-linux.zip"

if [[ $EUID == 0 ]]; then
	echo "Please don't run this script with sudo. Run it like this:"
	echo "bash install.sh"
	exit 1
fi

if [ "$1" == "--uninstall" ]; then

	rm -f $launcher $association
	rm -f ~/.local/share/icons/hicolor/*/{apps,mimetypes}/bootstrapstudio*

	if [ -x "$(command -v update-mime-database)" ]; then
		update-mime-database ~/.local/share/mime
	fi

	if [ -x "$(command -v update-desktop-database)" ]; then
		update-desktop-database ~/.local/share/applications
	fi

	echo 'Bootstrap Studio Crack was uninstalled'

	exit 0
fi


echo
echo '==================================================================='
echo 'Bootstrap Studio Linux Crack Install'
echo '==================================================================='
echo
echo 'This script will download and set up desktop integration for '
echo 'Bootstrap Studio Crack [v5.8.3]'
echo
echo 'It will create a launcher icon which shows up in the list of your'
echo 'installed programs, and will register *.bsdesign and *.bscomp files'
echo 'to open in the app.'
echo
echo 'To uninstall at a later time, pass the uninstall flag:'
echo '$ install.sh --uninstall'
echo
echo '==================================================================='
echo
echo 'Proceed? (y/n)'

read choice

if [ "$choice" != "y" ]; then
	echo 'Exiting'
	exit 0
fi


echo "Checking for wget..."
if command -v wget > /dev/null; then
  echo "Detected wget..."
else
  echo "Please install wget and unzip..."
  exit 0
fi

echo "Checking for unzip..."
if command -v unzip > /dev/null; then
  echo "Detected curl..."
else
  echo "Please install wget and unzip..."
  exit 1
fi

echo
echo "Downloading file please wait..."
echo
cd ~/Downloads
wget $URL
echo
echo
unzip -o Bootstrap-Studio-5.8.3_x64-linux.zip

mv -r ~/Downloads/Bootstrap-Studio-5.8.3_x64-linux/bstudio ~/

rm -r ~/Downloads/Bootstrap-Studio-5.8.3_x64-linux

# Create a desktop launcher
mkdir -p ~/.local/share/applications/

cat > $launcher <<- EOM
[Desktop Entry]
Encoding=UTF-8
Version=5.8.3
Type=Application
Name=Bootstrap Studio
Path=~/bstudio
Icon=~/bstudio/bstudio.png
Exec=~/bstudio/AppRun
Comment=A Powerful Web Design & Development Tool
Categories=Development;
StartupNotify=false
StartupWMClass=Bootstrap Studio
Terminal=false
MimeType=application/x-bstudio-design;application/x-bstudio-component
EOM

chmod u+x $launcher

if [ -x "$(command -v gio)" ]; then
	gio set $launcher "metadata::trusted" true 2> /dev/null || true
fi

if [ -x "$(command -v update-desktop-database)" ]; then
	update-desktop-database ~/.local/share/applications
fi

# File associations

mkdir -p ~/.local/share/mime/packages

cat > $association <<- EOM
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
   <mime-type type="application/x-bstudio-design">
     <comment>Bootstrap Studio Design</comment>
     <glob pattern="*.bsdesign"/>
     <icon name="bootstrapstudio-design"/>
   </mime-type>
   <mime-type type="application/x-bstudio-component">
     <comment>Bootstrap Studio Component</comment>
     <glob pattern="*.bscomp"/>
     <icon name="bootstrapstudio-component"/>
   </mime-type>
</mime-info>
EOM

if [ -x "$(command -v update-mime-database)" ]; then
	update-mime-database ~/.local/share/mime
fi

echo
echo 'Bootstrap Studio Crack v5.8.3 was installed.'
