#!/bin/bash

set -e

if [ -z "$1" ]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    cd ${DIR}/images/linux
else
    cd $1
fi


source /tools/Xilinx/Vitis/2020.1/settings64.sh
source ~/petalinux/2020.1/settings.sh
# source /tools/Xilinx/Vitis/2019.2/settings64.sh
# source ~/petalinux/2019.2/settings.sh
petalinux-package --boot --u-boot --kernel --force --fpga

rm -rf /media/kd/boot/*
cp BOOT.BIN image.ub boot.scr /media/kd/boot

sudo rm -rf /media/kd/root/*
sudo tar -xf rootfs.tar.gz -C /media/kd/root

sync

sudo umount /media/kd/boot
sudo umount /media/kd/root
