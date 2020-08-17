#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${DIR}

echo "flashing sd card"

rm -rf /media/kd/boot/*
cp -r output/* /media/kd/boot

sudo rm -rf /media/kd/root/*
sudo tar -xf ./buildroot-2020.02.4/output/images/rootfs.tar.gz -C /media/kd/root

sync

sudo umount /media/kd/boot
sudo umount /media/kd/root
