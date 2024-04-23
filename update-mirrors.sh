#!/bin/bash

country=BR

url="https://www.archlinux.org/mirrorlist/?country=${country}&protocol=http&ip_version=4&use_mirror_status=on"

tmpfile=$(mktemp --suffix=-mirrorlist)

echo 'Download best up-to-date mirrors...'
wget -q -O - $url | sed 's/#Server/Server/;/^#/d;/^$/d' | head -n 10 > $tmpfile

# Check if file contains data
if [[ -s $tmpfile ]]; then
    echo 'Copy new mirrorlist sorted by connection speed...'
    rankmirrors $tmpfile > /etc/pacman.d/mirrorlist
else
    echo "Error receiving new mirrorlist."
fi

echo 'Deleting temp file...'
rm $tmpfile
echo 'DONE!'
cat /etc/pacman.d/mirrorlist

