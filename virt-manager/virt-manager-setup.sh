#!/bin/bash

set -e

sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt $USER
