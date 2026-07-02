#!/bin/bash

set -e

echo "Configuring firewalld for libvirt networking..."

sudo firewall-cmd --permanent --zone=libvirt --add-masquerade
sudo firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -s 192.168.122.0/24 -j ACCEPT
sudo firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -d 192.168.122.0/24 -j ACCEPT
sudo firewall-cmd --permanent --direct --add-rule ipv4 nat POSTROUTING 0 -s 192.168.122.0/24 ! -d 192.168.122.0/24 -j MASQUERADE

sudo firewall-cmd --reload
sudo systemctl restart libvirtd

echo "Done. VM networking should work now."
