#!/usr/bin/env sh
set -x
sudo apt-get update
sudo apt-get install -y ca-certificates openjdk-21-jre-headless curl jq
useradd -m -s /bin/bash minecrafter 

tic -x -o /usr/share/terminfo /tmp/ghostty.terminfo
