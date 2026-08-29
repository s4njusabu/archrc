#!/bin/bash

set -e

sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt $USER

sudo virsh net-list --all
sudo virsh net-autostart default
sudo virsh net-start default
