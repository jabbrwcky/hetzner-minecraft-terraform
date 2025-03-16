#!/usr/bin/env bash

cloud-init clean --logs --machine-id --seed --configs all
rm -rvf /var/lib/cloud/instances /etc/machine-id /var/lib/dbus/machine-id /var/log/cloud-init*

rm -rf /run/cloud-init/*
rm -rf /var/lib/cloud/*

export DEBIAN_FRONTEND=noninteractive

apt-get -y autopurge
apt-get -y clean

rm -rf /var/lib/apt/lists/*

journalctl --flush
journalctl --rotate --vacuum-time=0

find /var/log -type f -exec truncate --size 0 {} \; # truncate system logs
find /var/log -type f -name '*.[1-9]' -delete # remove archived logs
find /var/log -type f -name '*.gz' -delete # remove compressed archived logs

rm -f /etc/ssh/ssh_host_*_key /etc/ssh/ssh_host_*_key.pub

dd if=/dev/zero of=/zero bs=4M || true
sync
rm -f /zero
