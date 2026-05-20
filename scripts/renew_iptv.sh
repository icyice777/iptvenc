#!/bin/bash

# Creates a blue notice icon in the logs
echo "::notice::The script started successfully."

# Download m3u file
curl https://raw.githubusercontent.com/Free-TV/IPTV/master/playlist.m3u8 > ../iptv.m3u