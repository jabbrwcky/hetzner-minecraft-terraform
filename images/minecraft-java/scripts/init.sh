#!/usr/bin/env sh
set -x

chown -R minecrafter:minecrafter /home/minecrafter

sudo -u minecrafter java -jar /home/minecrafter/server.jar --initSettings