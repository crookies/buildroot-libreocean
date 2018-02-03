#!/bin/sh

BOARD_DIR="$(dirname $0)"
GENIMAGE_CFG="${BOARD_DIR}/genimage.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

cp ${BOARD_DIR}/boot.ini ${BINARIES_DIR}/

rm -rf "${GENIMAGE_TMP}"

genimage                           \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

#dd if=${BINARIES_DIR}/u-boot.bin of=${BINARIES_DIR}/sdcard.img bs=1 count=442 conv=sync,notrunc
#dd if=${BINARIES_DIR}/u-boot.bin of=${BINARIES_DIR}/sdcard.img bs=512 skip=1 seek=1 conv=fsync,notrunc

signed_bl1_position=0
bl2_position=30
uboot_position=62
tzsw_position=1502
device="${BINARIES_DIR}/sdcard.img"
uboot="${BINARIES_DIR}/u-boot-dtb.bin"

env_position=2015

#<BL1 fusing>
echo "BL1 fusing"
dd if=${BINARIES_DIR}/bl1.bin.hardkernel of=$device seek=$signed_bl1_position conv=fsync,notrunc

#<BL2 fusing>
echo "BL2 fusing"
dd if=${BINARIES_DIR}/bl2.bin.hardkernel.720k_uboot of=$device seek=$bl2_position conv=fsync,notrunc

#<u-boot fusing>
echo "u-boot fusing"
dd if=$uboot of=$device seek=$uboot_position conv=fsync,notrunc

#<TrustZone S/W fusing>
echo "TrustZone S/W fusing"
dd if=${BINARIES_DIR}/tzsw.bin.hardkernel of=$device seek=$tzsw_position conv=fsync,notrunc

#<u-boot env erase>
echo "u-boot env erase..."
dd if=/dev/zero of=$device seek=$env_position bs=512 count=32 conv=fsync,notrunc


