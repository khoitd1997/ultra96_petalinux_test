#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${DIR}/images/linux

source ~/petalinux/2020.1/settings.sh
petalinux-package --boot --u-boot --kernel --force

rm -rf /media/kd/boot/*
cp BOOT.BIN image.ub boot.scr /media/kd/boot

sudo rm -rf /media/kd/root/*
sudo tar -xf rootfs.tar.gz -C /media/kd/root

sync

sudo umount /media/kd/boot
sudo umount /media/kd/root
