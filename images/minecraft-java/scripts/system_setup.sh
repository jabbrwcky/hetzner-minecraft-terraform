#!/usr/bin/env sh
set -x
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

sudo apt-get update
sudo apt-get install -y ca-certificates openjdk-21-jre-headless curl jq tailscale
useradd -m -s /bin/bash minecrafter 

tic -x -o /usr/share/terminfo /tmp/ghostty.terminfo


