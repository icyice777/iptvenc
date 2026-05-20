#!/bin/bash

# Creates a blue notice icon in the logs
echo "::notice::The script started successfully."

# Download m3u file
curl https://raw.githubusercontent.com/Free-TV/IPTV/master/playlist.m3u8 > iptv.m3u
echo "::notice::iptv.m3u has been downloaded successfully."

# Encrypt iptv.m3u file
openssl enc -in iptv.m3u -out iptv.enc.m3u -e -$algorithm -iv $ivHex -pbkdf2 -pass pass:$password -S $saltHex -iter $iterations -md $diggest
echo "::notice::iptv.m3u has been encrypted successfully."