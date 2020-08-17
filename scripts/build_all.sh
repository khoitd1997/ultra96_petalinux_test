#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${DIR}

source /tools/Xilinx/Vitis/2020.1/settings64.sh
export CROSS_COMPILE=aarch64-linux-gnu-

## DTC and DTS
make -j$(nproc) -C dtc
export PATH=$PATH:${DIR}/dtc

# rm -rf my_dts/*
# cd repo/my_dt/device-tree-xlnx
# git checkout xilinx-v2020.1
# cd ${DIR}

# xsct dtb.tcl
gcc -I my_dts -I linux-xlnx -E -nostdinc -undef -D__DTS__ -x assembler-with-cpp -o my_dts/system-top.dts.tmp my_dts/system-top.dts
dtc -I dts -O dtb -o my_dts/system-top.dtb my_dts/system-top.dts.tmp

## Linux
cd linux-xlnx
export ARCH=arm64
echo "Building kernel"
# git checkout xilinx-v2020.1
# make xilinx_zynqmp_defconfig
make -j$(nproc)
cd ${DIR}

echo "Building Buildroot"
cd ./buildroot-2020.02.4/
make -j$(nproc)
cd ${DIR}

## Uboot
echo "Building u-boot"
cd u-boot-xlnx
export ARCH=aarch64
# git checkout xilinx-v2020.1
# make xilinx_zynqmp_virt_defconfig
make -j$(nproc)
cd ${DIR}
mv u-boot-xlnx/u-boot.elf boot_components
u-boot-xlnx/tools/mkimage -f fitimage.its fitimage.itb
cp fitimage.itb linux_image

## BOOT.bin
bootgen -arch zynqmp -image linux.bif -o i BOOT.BIN -w on
u-boot-xlnx/tools/mkimage -c none -A arm -T script -d boot.cmd boot.scr
cp boot.scr linux_image

mv BOOT.BIN fitimage.itb output